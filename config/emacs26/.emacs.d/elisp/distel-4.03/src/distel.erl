%%%-------------------------------------------------------------------
%%% File    : distel.erl
%%% Author  : Luke Gorrie <luke@bluetail.com>
%%% Purpose : Helper functions to be called from Emacs.
%%%
%%% Created : 18 Mar 2002 by Luke Gorrie <luke@bluetail.com>
%%%-------------------------------------------------------------------
-module(distel).

-author('luke@bluetail.com').

-include_lib("kernel/include/file.hrl").

-import(lists, [flatten/1, member/2, sort/1, map/2, foldl/3, foreach/2]).
-import(filename, [dirname/1,join/1,basename/2]).

-export([rpc_entry/3, eval_expression/1, find_source/1,
         process_list/0, process_summary/1,
         process_summary_and_trace/2, fprof/3, fprof_analyse/1,
         debug_toggle/2, debug_subscribe/1, debug_add/1,
         break_toggle/2, break_delete/2, break_add/2, break_restore/1,
         modules/1, functions/2, who_calls/3,
         rebuild_completions/0, rebuild_call_graph/0,
         free_vars/1, free_vars/2,
         apropos/1, apropos/2, describe/3, describe/4]).

-export([reload_module/2,reload_modules/0]).

-export([gl_proxy/1, tracer_init/2, null_gl/0]).

-compile(export_all).

to_bin(X) -> list_to_binary(to_list(X)).
to_atom(X) -> list_to_atom(to_list(X)).
     
to_list(X) when is_binary(X) -> binary_to_list(X);
to_list(X) when is_integer(X)-> integer_to_list(X);
to_list(X) when is_float(X)  -> float_to_list(X);
to_list(X) when is_atom(X)   -> atom_to_list(X);
to_list(X) when is_list(X)   -> X.		%Assumed to be a string

%% ----------------------------------------------------------------------
%% RPC entry point, adapting the group_leader protocol.

rpc_entry(M, F, A) ->
    GL = group_leader(),
    Name = gl_name(GL),
    case whereis(Name) of
        undefined ->
            Pid = spawn(?MODULE, gl_proxy, [GL]),
            register(Name, Pid),
            group_leader(Pid, self());
        Pid ->
            group_leader(Pid, self())
    end,
    apply(M,F,A).

gl_name(Pid) ->
    to_atom(flatten(io_lib:format("distel_gl_for_~p", [Pid]))).

gl_proxy(GL) ->
    receive
        {io_request, From, ReplyAs, {put_chars, C}} ->
            GL ! {put_chars, C},
            From ! {io_reply, ReplyAs, ok};
        {io_request, From, ReplyAs, {put_chars, M, F, A}} ->
            GL ! {put_chars, flatten(apply(M, F, A))},
            From ! {io_reply, ReplyAs, ok};
        {io_request, From, ReplyAs, {get_until, _, _, _}} ->
            %% Input not supported, yet
            From ! {io_reply, ReplyAs, eof}
    end,
    gl_proxy(GL).

%% ----------------------------------------------------------------------
%%% reload all modules that are out of date
%%% compare the compile time of the loaded beam and the beam on disk
reload_modules() ->
    T = fun(L) -> [X || X <- L, element(1,X)==time] end,
    Tm = fun(M) -> T(M:module_info(compile)) end,
    Tf = fun(F) -> {ok,{_,[{_,I}]}}=beam_lib:chunks(F,[compile_info]),T(I) end,
    Load = fun(M) -> c:l(M),M end,
    
    [Load(M) || {M,F} <- code:all_loaded(), is_beamfile(F), Tm(M)<Tf(F)].

is_beamfile(F) -> 
    ok == element(1,file:read_file_info(F)) andalso
	".beam" == filename:extension(F).

%% ----------------------------------------------------------------------
%% if c:l(Mod) doesn't work, we look for the beam file in 
%% srcdir and srcdir/../ebin; add the first one that works to path and 
%% try c:l again.
%% srcdir is dirname(EmacsBuffer); we check that the buffer contains Mod.erl
%% emacs will set File = "" to indicate that we don't want to mess with path
reload_module(Mod, File) ->
    case c:l(to_atom(Mod)) of
	{error,R} ->
	    case Mod == basename(File,".erl") of
		true ->
		    Beams = [join([dirname(File),Mod]),
			     join([dirname(dirname(File)),ebin,Mod])],
			case lists:filter(fun is_beam/1, Beams) of
			    [] -> {error, R};
			    [Beam|_] -> 
				code:add_patha(dirname(Beam)),
				c:l(to_atom(Mod))
			end;
		false ->
		    {error,R}
	    end;
	R -> R
    end.

is_beam(Filename) ->
    case file:read_file_info(Filename++".beam") of
	{ok,_} -> true;
	{error,_} -> false
    end.
	    
%% ----------------------------------------------------------------------

eval_expression(S) ->
    case parse_expr(S) of
        {ok, Parse} ->
            try_evaluation(Parse);
        {error, {_, erl_parse, Err}} ->
            {error, Err}
    end.

try_evaluation(Parse) ->
    case catch erl_eval:exprs(Parse, []) of
        {value, V, _} ->
            {ok, flatten(io_lib:format("~p", [V]))};
        {'EXIT', Reason} ->
            {error, Reason}
    end.

parse_expr(S) ->
    {ok, Scan, _} = erl_scan:string(S),
    erl_parse:parse_exprs(Scan).

find_source(Mod) ->
  case beamfile(Mod) of
    {ok, BeamFName} ->
      try {ok,guess_source_file(Mod, BeamFName)}
      catch
        nothing -> {error,fmt("Can't find source for ~p", [BeamFName])};
        several -> {error,fmt("Several possible sources for ~p", [BeamFName])};
	_:R -> {error,fmt("Couldnt guess source ~p ~p",[BeamFName,R])}
      end;
    error ->
      {error, fmt("Can't find module '~p' on ~p", [Mod, node()])}
  end.

%% Ret: AbsName | throw(Reason)
guess_source_file(Mod, BeamFName) ->
  Erl = to_list(Mod) ++ ".erl",
  Dir = dirname(BeamFName),
  DotDot = dirname(Dir),
  try_srcs([src_from_beam(Mod),
            join([Dir, Erl]),
            join([DotDot, src, Erl]),
            join([DotDot, src, "*", Erl]),
            join([DotDot, esrc, Erl]),
            join([DotDot, erl, Erl])]).

try_srcs([]) -> throw(nothing);
try_srcs(["" | T]) -> try_srcs(T);
try_srcs([H | T]) ->
  case filelib:wildcard(H) of
    [File] -> 
      case filelib:is_regular(File) of 
        true -> File;
        false-> try_srcs(T)
      end;
    [] -> try_srcs(T);
    _Multi -> throw(several)
  end.

src_from_beam(Mod) ->
  try 
    case Mod:module_info(compile) of
      [] -> int:file(Mod);
      CompInfo -> {_,{_,Src}} = lists:keysearch(source,1,CompInfo), Src
    end
  catch _:_ -> ""
  end.

%% ----------------------------------------------------------------------
%% Summarise all processes in the system.
%%
%% Returns: {Heading, [{pid(), Row}]}
%% Heading = Row = binary()
process_list() ->
    Heading = iformat("PID/Name", "Initial Call", "Reds", "Msgs"),
    {Heading, [{Pid, iformat_pid(Pid)} || Pid <- processes()]}.

iformat_pid(Pid) ->
    iformat(name(Pid), initial_call(Pid), reductions(Pid), messages(Pid)).

name(Pid) ->
    case process_info(Pid, registered_name) of
        {registered_name, Regname} ->
            to_list(Regname);
        _ ->
            io_lib:format("~p", [Pid])
    end.

initial_call(Pid) ->
    {initial_call, {M, F, A}} = process_info(Pid, initial_call),
    io_lib:format("~s:~s/~p", [M, F, A]).

reductions(Pid) ->
    {reductions, NrReds} = process_info(Pid, reductions),
    to_list(NrReds).

messages(Pid) ->
    {messages, MsgList} = process_info(Pid, messages),
    to_list(length(MsgList)).

iformat(A1, A2, A3, A4) ->
    to_bin(io_lib:format("~-21s ~-33s ~12s ~8s~n",
                                 [A1,A2,A3,A4])).

%% ----------------------------------------------------------------------
%% Individual process summary and tracing.

%% Returns: {ok, String} | {error, Rsn}
process_info_item(Pid, Item) ->
    case process_info(Pid, Item) of
        {backtrace, Bin} ->
            {ok, Bin};
        {Item, Term} ->
            {ok, fmt("~p~n", [Term])};
        undefined ->
            case is_process_alive(Pid) of
                true ->
                    {ok, <<"undefined">>};
                false ->
                    {ok, fmt("dead process: ~p", [Pid])}
            end
    end.

%% Returns: Summary : binary()
process_summary(Pid) ->
    Text = [io_lib:format("~-20w: ~w~n", [Key, Value])
            || {Key, Value} <- [{pid, Pid} | process_info(Pid)]],
    to_bin(Text).

%% Returns: Summary : binary()
%%
%% Tracer is sent messages of:
%%    {trace_msg, binary()}
process_summary_and_trace(Tracer, Pid) ->
    case is_process_alive(Pid) of
        true ->
            spawn_tracer(Tracer, Pid),
            process_summary(Pid);
        false ->
            {error, fmt("dead process: ~p", [Pid])}
    end.

spawn_tracer(Tracer, Tracee) ->
    spawn(?MODULE, tracer_init, [Tracer, Tracee]).

tracer_init(Tracer, Tracee) ->
    link(Tracer),
    erlang:trace(Tracee, true, trace_flags()),
    tracer_loop(Tracer, Tracee).

trace_flags() ->
    [send, 'receive', running, procs, garbage_collection, call, return_to].

tracer_loop(Tracer, Tracee) ->
    receive
        Trace when tuple(Trace),
                   element(1, Trace) == trace,
                   element(2, Trace) == Tracee ->
            Msg = tracer_format(Trace),
            Tracer ! {trace_msg, to_bin(Msg)}
    end,
    tracer_loop(Tracer, Tracee).

tracer_format(Msg) ->
    %% Let's steal some code reuse..
    pman_buf_utils:textformat(Msg).

%% ----------------------------------------------------------------------
%% Profiling
%% fprof_expr(E) -> {ok, Preamble, Header, Entry}
%% Preamble = binary()
%% Entry = {Tag, MFA, Text, Callers, Callees, Beamfile}
%% Callers = Callees = [Tag]
%% MFA = [Module, Function, Arity] | undefined
%%
%% Entry example,
%%   {'foo:bar/2', "foo:bar/2  10 100 200", ['baz:beer/2'], [], "/foo.beam"}

fprof(Expr) ->
    case parse_expr(Expr) of
        {ok, Parse} ->
            fprof_fun(fun() -> erl_eval:exprs(Parse, []) end);
        {error, Rsn} ->
            {error, Rsn}
    end.

fprof(M,F,A) ->
    fprof_fun(fun() -> apply(M,F,A) end).

fprof_fun(F) ->
    GL = spawn_link(fun null_gl/0),
    group_leader(GL, self()),
    fprof:apply(F, []),
    fprof:profile(),
    fprof:analyse({dest, "/tmp/fprof.analysis"}),
    GL ! die,
    fprof_analyse("/tmp/fprof.analysis").

fprof_analyse(Filename) ->
    {ok, Asys} = file:consult(Filename),
    [_Opts, [Totals], _Proc | Fns] = Asys,
    {ok,
     fprof_preamble(Totals),
     fprof_header(),
     [fprof_entry(Entry) || Entry <- Fns]}.
    
fprof_preamble({totals, Cnt, Acc, Own}) ->
    fmt("Totals: ~p calls, ~.3f real, ~.3f CPU\n\n", [Cnt, Acc, Own]).

fprof_header() ->
    fmt("~sCalls\tACC\tOwn\n", [pad(50, "Function")]).

fprof_entry([{ProcName, _Cnt, _Acc, Own} | Info]) ->
    %% {process, Name, [Infos]}
    {process, fmt("Process ~s: ~p%", [ProcName, Own]),
     map(fun fprof_process_info/1, Info)};
fprof_entry(F) ->
    {Up, This, Down} = F,
    {Name, _, _, _} = This,
    {tracepoint,
     fprof_tag(Name),
     fprof_mfa(Name),
     fprof_text(This),
     fprof_tags(Up),
     fprof_tags(Down),
     fprof_beamfile(Name)}.

fprof_process_info({spawned_by, Who}) ->
    fmt("  ~s: ~s", [pad(16, "spawned_by"), Who]);
fprof_process_info({spawned_as, What}) ->
    fmt("  ~s: ~s", [pad(16, "spawned as"),
                   fprof_tag_name(What)]);
fprof_process_info({initial_calls, Calls}) ->
    fmt("  ~s: ~p~n", [pad(16, "initial calls"), Calls]);
fprof_process_info(Info) ->
    fmt("  ???: ~p~n", [Info]).

fprof_tag({M,F,A}) when integer(A) ->
    to_atom(flatten(io_lib:format("~p:~p/~p", [M,F,A])));
fprof_tag({M,F,A}) when list(A) ->
    fprof_tag({M,F,length(A)});
fprof_tag(Name) when  atom(Name) ->
    Name.

fprof_mfa({M,F,A}) -> [M,F,A];
fprof_mfa(_)       -> undefined.

fprof_tag_name(X) -> flatten(io_lib:format("~s", [fprof_tag(X)])).

fprof_text({Name, Cnt, Acc, Own}) ->
    fmt("~s~p\t~.3f\t~.3f\n",
        [pad(50, fprof_tag_name(Name)), Cnt, Acc, Own]).

fprof_tags(C) -> [fprof_tag(Name) || {Name,_,_,_} <- C].

fprof_beamfile({M,_,_}) ->
    case code:which(M) of
        Fname when list(Fname) ->
            to_bin(Fname);
        _ ->
            undefined
    end;
fprof_beamfile(_)                  -> undefined.

fmt(X, A) -> to_bin(io_lib:format(X, A)).

pad(X, A) when atom(A) ->
    pad(X, to_list(A));
pad(X, S) when length(S) < X ->
    S ++ lists:duplicate(X - length(S), $ );
pad(_X, S) ->
    S.

null_gl() ->
    receive
        {io_request, From, ReplyAs, _} ->
            From ! {io_reply, ReplyAs, ok},
            null_gl();
        die ->
            ok
    end.

%% ----------------------------------------------------------------------
%% Debugging
%% ----------------------------------------------------------------------
debug_toggle(Mod, Filename) ->
    case member(Mod, int:interpreted()) of
        true ->
            int:n(Mod),
            uninterpreted;
        false ->
            case code:ensure_loaded(Mod) of
	        {error,nofile} -> error;
	        {module,Mod} -> 
		    case int:i(Mod)  of
		        {module, Mod} -> interpreted;
		        error ->
			    case int:i(Filename)  of
			        {module, Mod} -> interpreted;
			        error -> error
			    end
		    end
	    end
    end.

debug_add(Modules) ->
    foreach(fun([_Mod, FileName]) ->
		    %% FIXME: want to reliably detect whether
		    %% the module is interpreted, but
		    %% 'int:interpreted()' can give the wrong
		    %% answer if code is reloaded behind its
		    %% back.. -luke
		    int:i(FileName)
	    end, Modules),
    ok.

break_toggle(Mod, Line) ->
    case lists:any(fun({Point,_}) -> Point == {Mod,Line} end,
                   int:all_breaks()) of
        true ->
            ok = int:delete_break(Mod, Line),
            disabled;
        false ->
            ok = int:break(Mod, Line),
            enabled
    end.

break_delete(Mod, Line) ->
    case lists:any(fun({Point,_}) -> Point == {Mod,Line} end,
                   int:all_breaks()) of
        true ->
            ok = int:delete_break(Mod, Line);
        false ->
            ok
    end.

break_add(Mod, Line) ->
    case lists:any(fun({Point,_}) -> Point == {Mod,Line} end,
                   int:all_breaks()) of
        true ->
            ok;
        false ->
            ok = int:break(Mod, Line)
    end.

%% L = [[Module, [Line]]]
break_restore(L) ->
    foreach(
      fun([Mod, Lines]) ->
              foreach(fun(Line) -> int:break(Mod, Line) end, Lines)
      end, L),
    ok.


fname(Mod) ->
    filename:rootname(code:which(Mod), "beam") ++ "erl".

%% Returns: {InterpretedMods, Breakpoints, [{Pid, Text}]}
%%          InterpretedMods = [[Mod, File]]
%%          Breakpoints     = [{Mod, Line}]
debug_subscribe(Pid) ->
    %% NB: doing this before subscription to ensure that the debugger
    %% server is started (int:subscribe doesn't do this, probably a
    %% bug).
    Interpreted = lists:map(fun(Mod) -> [Mod, fname(Mod)] end,
                            int:interpreted()),
    spawn_link(?MODULE, debug_subscriber_init, [self(), Pid]),
    receive ready -> ok end,
    int:clear(),
    {Interpreted,
     [Break || {Break, _Info} <- int:all_breaks()],
     [{Proc,
       fmt("~p:~p/~p", [M,F,length(A)]),
       fmt("~w", [Status]),
       fmt("~w", [Info])}
      || {Proc, {M,F,A}, Status, Info} <- int:snapshot()]}.

debug_subscriber_init(Parent, Pid) ->
    link(Pid),
    int:subscribe(),
    Parent ! ready,
    debug_subscriber(Pid).

debug_subscriber(Pid) ->
    receive
	{int, {new_status, P, Status, Info}} ->
	    Pid ! {int, {new_status, P, Status, fmt("~w",[Info])}};
	{int, {new_process, {P, {M,F,A}, Status, Info}}} ->
	    Pid ! {int, {new_process,
			 [P,
			  fmt("~p:~p/~p", [M,F,length(A)]),
			  Status,
			  fmt("~w", [Info])]}};
	{int, {interpret, Mod}} ->
	    Pid ! {int, {interpret, Mod, fname(Mod)}};
	Msg ->
	    Pid ! Msg
    end,
    debug_subscriber(Pid).

debug_format(Pid, {M,F,A}, Status, Info) ->
    debug_format_row(io_lib:format("~w", [Pid]),
                     io_lib:format("~p:~p/~p", [M,F,length(A)]),
                     io_lib:format("~w", [Status]),
                     io_lib:format("~w", [Info])).

debug_format_row(Pid, MFA, Status, Info) ->
    fmt("~-12s ~-21s ~-9s ~-21s~n", [Pid, MFA, Status, Info]).

%% Attach the client process Emacs to the interpreted process Pid.
%%
%% spawn_link's a new process to proxy messages between Emacs and
%% Pid's meta-process.
debug_attach(Emacs, Pid) ->
    spawn_link(?MODULE, attach_init, [Emacs, Pid]).

%% State for attached process, based on `dbg_ui_trace' in the debugger.
-record(attach, {emacs,                 % pid()
                 meta,                  % pid()
                 status,                % break | running | idle | ...
                 where,                 % {Mod, Line}
                 stack                  % {CurPos, MaxPos}
                }).

attach_init(Emacs, Pid) ->
    link(Emacs),
    case int:attached(Pid) of
        {ok, Meta} ->
            attach_loop(#attach{emacs=Emacs,
				meta=Meta,
				status=idle,
				stack={undefined,undefined}});
        error ->
            exit({error, {unable_to_attach, Pid}})
    end.

attach_loop(Att = #attach{emacs=Emacs, meta=Meta}) ->
    receive 
	{Meta, {break_at, Mod, Line, Pos}} ->
	    Att1 = Att#attach{status=break,
			      where={Mod, Line},
			      stack={Pos, Pos}},
	    ?MODULE:attach_loop(attach_goto(Att1,Att1#attach.where));
	{Meta, Status} when atom(Status) ->
	    Emacs ! {status, Status},
	    ?MODULE:attach_loop(Att#attach{status=Status,where=undefined});
	{NewMeta, {exit_at,null,_R,Pos}} when is_pid(NewMeta) ->
	    %% exit, no stack info
	    Att1 = Att#attach{status=exit,
			      where=undefined,
			      meta=NewMeta,
			      stack={Pos, Pos}},
	    ?MODULE:attach_loop(Att1);
	{NewMeta, {exit_at,{Mod,Line},_R,Pos}} when is_pid(NewMeta) ->
	    %% exit on error, there is stack info
	    Att1 = Att#attach{meta = NewMeta,
			      status=break,
			      where={Mod,Line},
			      stack={Pos+1, Pos+1}},
	    ?MODULE:attach_loop(attach_goto(Att1,Att1#attach.where));
	{Meta, {attached,_Mod,_Lin,_Flag}} ->
	    %% happens first time we attach, presumably because we (or
	    %% someone else) set a break here
	    ?MODULE:attach_loop(Att);
	{Meta,{re_entry, Mod, Func}} -> 
	    Msg = "re_entry "++to_list(Mod)++to_list(Func),
	    Emacs ! {message, to_bin(Msg)},
	    ?MODULE:attach_loop(Att);
	{Meta, _X} ->
	    %%io:fwrite("distel:attach_loop OTHER meta: ~p~n", [_X]),
	    %% FIXME: there are more messages to handle, like re_entry
	    ?MODULE:attach_loop(Att);
	{emacs, meta, Cmd} when Att#attach.status == break ->
	    attach_loop(attach_meta_cmd(Cmd, Att));
	{emacs, meta, _Cmd} ->
	    Emacs ! {message, <<"Not in break">>},
	    ?MODULE:attach_loop(Att);
	_X ->
	    %%io:fwrite("distel:attach_loop OTHER: ~p~n", [_X]),
	    ?MODULE:attach_loop(Att)
    end.

attach_meta_cmd(up, Att = #attach{stack={Pos,Max}}) ->
    case int:meta(Att#attach.meta, stack_frame, {up, Pos}) of
	{NPos, {undefined, -1},[]} ->  %OTP R10
	    Att#attach.emacs ! {message, <<"uninterpreted code.">>},
	    Att#attach{stack={NPos,Max}};
	{NPos, {Mod, Line},Binds} ->  %OTP R10
	    attach_goto(Att#attach{stack={NPos,Max}},{Mod,Line},Binds);
	{NPos, Mod, Line} ->		   %OTP R9
	    attach_goto(Att#attach{stack={NPos,Max}},{Mod,Line});
	top ->
	    Att#attach.emacs ! {message, <<"already at top.">>},
	    Att
    end;
attach_meta_cmd(down, Att = #attach{stack={_Max,_Max}}) ->
    Att#attach.emacs ! {message, <<"already at bottom">>},
    Att;
attach_meta_cmd(down, Att = #attach{stack={Pos,Max}}) ->
    case int:meta(Att#attach.meta, stack_frame, {down, Pos}) of
	{NPos, {undefined, -1},[]} ->  %OTP R10
	    Att#attach.emacs ! {message, <<"uninterpreted code.">>},
	    Att#attach{stack={NPos,Max}};
	{NPos, {Mod, Line},Binds} ->  %OTP R10
	    attach_goto(Att#attach{stack={NPos,Max}},{Mod,Line},Binds);
	{NPos, Mod, Line} ->		   %OTP R9
	    attach_goto(Att#attach{stack={NPos,Max}},{Mod,Line});
	bottom ->
	    attach_goto(Att#attach{stack={Max, Max}},Att#attach.where)
    end;
attach_meta_cmd({get_binding, Var}, Att = #attach{stack={Pos,_Max}}) ->
    Bs = int:meta(Att#attach.meta, bindings, Pos),
    case lists:keysearch(Var, 1, Bs) of
	{value, Val} ->
	    Att#attach.emacs ! {show_variable, fmt("~p~n", [Val])};
	false ->
	    Att#attach.emacs ! {message, fmt("No such variable: ~p",[Var])}
    end,
    Att;
attach_meta_cmd(Cmd, Att) ->
    int:meta(Att#attach.meta, Cmd),
    Att.

attach_goto(A,ML) ->
    attach_goto(A,ML,sort(int:meta(A#attach.meta, bindings, stack_pos(A)))).
attach_goto(A = #attach{stack={Pos,Max}},{Mod,Line},Bs) ->
    Vars = [{Name, fmt("~9s = ~P~n", [Name, Val, 9])} || {Name,Val} <- Bs],
    A#attach.emacs ! {variables, Vars},
    A#attach.emacs ! {location, Mod, Line, Pos, Max},
    A.
stack_pos(#attach{stack={_X,_X}}) -> nostack;
stack_pos(#attach{stack={Pos,_Max}}) -> Pos.
    
%% ----------------------------------------------------------------------
%% Completion support
%% ----------------------------------------------------------------------

modules(Prefix) ->
  case otp_doc:modules(Prefix) of
    {ok,Ans} -> {ok,Ans};
    {error,_}-> xref_modules(Prefix)
  end.
functions(Mod, Prefix) -> 
  case otp_doc:functions(Mod,Prefix) of
    {ok,Ans} -> {ok,Ans};
    {error,_}-> xref_functions(Mod,Prefix)
  end.

-define(COMPLETION_SERVER, distel_complete).
-define(COMPLETION_SERVER_OPTS, {xref_mode, modules}).

rebuild_completions() ->
    rebuild(?COMPLETION_SERVER, ?COMPLETION_SERVER_OPTS).

%% Returns: [ModName] of all modules starting with Prefix.
%% ModName = Prefix = string()
xref_modules(Prefix) ->
    case  xref_q(?COMPLETION_SERVER, ?COMPLETION_SERVER_OPTS,
                 '"~s.*" : Mod', [Prefix]) of
	{ok, Mods} ->
	    {ok, [atom_to_list(Mod) || Mod <- Mods]};
	_ ->
	    {error, fmt("Can't find any matches for ~p", [Prefix])}
    end.

%% Returns: [FunName] of all exported functions of Mod starting with Prefix.
%% Mod = atom()
%% Prefix = string()
xref_functions(Mod, Prefix) ->
    case  xref_q(?COMPLETION_SERVER, ?COMPLETION_SERVER_OPTS,
                 '(X+B) * ~p:"~s.*"/_', [Mod, Prefix]) of
	{ok, Res} ->
	    {ok,lists:usort([atom_to_list(Fun) || {_Mod, Fun, _Arity}<-Res])};
	_ ->
	    {error, fmt("Can't find module ~p", [Mod])}
    end.

%% ----------------------------------------------------------------------
%% Refactoring
%% ----------------------------------------------------------------------

%% @spec free_vars(Text::string()) ->
%%           {ok, FreeVars::[atom()]} | {error, Reason::string()}
%% @equiv free_vars(Text, 1)

free_vars(Text) ->
    free_vars(Text, 1).

%% @spec free_vars(Text::string(), Line::integer()) ->
%%           {ok, FreeVars::[atom()]} | {error, Reason::string()}

free_vars(Text, StartLine) ->
    %% StartLine/EndLine may be useful in error messages.
    {ok, Ts, EndLine} = erl_scan:string(Text, StartLine),
    %%Ts1 = lists:reverse(strip(lists:reverse(Ts))),
    Ts2 = [{'begin', 1}] ++ Ts ++ [{'end', EndLine}, {dot, EndLine}],
    case erl_parse:parse_exprs(Ts2) of
        {ok, Es} ->
            E = erl_syntax:block_expr(Es),
            E1 = erl_syntax_lib:annotate_bindings(E, ordsets:new()),
            {value, {free, Vs}} = lists:keysearch(free, 1,
                                                  erl_syntax:get_ann(E1)),
            {ok, Vs};
        {error, {_Line, erl_parse, Reason}} ->
            {error, fmt("~s", [Reason])}
    end.

strip([{',', _}   | Ts]) -> strip(Ts);
strip([{';', _}   | Ts]) -> strip(Ts);
strip([{'.', _}   | Ts]) -> strip(Ts);
strip([{'|', _}   | Ts]) -> strip(Ts);
strip([{'=', _}   | Ts]) -> strip(Ts);
strip([{'dot', _} | Ts]) -> strip(Ts);
strip([{'->', _}  | Ts]) -> strip(Ts);
strip([{'||', _}  | Ts]) -> strip(Ts);
strip([{'of', _}  | Ts]) -> strip(Ts);
strip(Ts)                -> Ts.

%% ----------------------------------------------------------------------
%% Online documentation
%% ----------------------------------------------------------------------

apropos(RE, false) ->
    apropos(RE);
apropos(RE, true) ->
    fdoc:stop(),
    apropos(RE).

apropos(RE) ->
    fdoc_binaryify(fdoc:get_apropos(RE)).

describe(M, F, A, false) ->
    describe(M, F, A);
describe(M, F, A, true) ->
    fdoc:stop(),
    describe(M, F, A).

describe(M, F, A) ->
%% FIXME using nonm-cached version instead.  remove old code
    fdoc_binaryify(fdoc:describe2(M, F, A)).
%    fdoc_binaryify(fdoc:description(M, F, A)).

%% Converts strings to binaries, for Emacs
fdoc_binaryify({ok, Matches}) ->
    {ok, [{M, F, A, to_bin(Doc)} || {M, F, A, Doc} <- Matches]};
fdoc_binaryify(Other) -> Other.

%% ----------------------------------------------------------------------
%% Argument list snarfing
%% ----------------------------------------------------------------------

%% Given the name of a function we return the argument lists for each
%% of its definitions (of different arities). The argument lists are
%% heuristically derived from the patterns in each clause of the
%% function. We try to derive the most human-meaningful arglist we
%% can.

%% Entry point;
%% Get the argument lists for a function in a module.
%% Return: [Arglist]
%% Arglist = [string()]
get_arglists(ModName, FunName) when list(ModName), list(FunName) ->
    arglists(to_atom(ModName), FunName).

arglists(Mod, Fun) ->
    case get_abst_from_debuginfo(Mod) of
	{ok, Abst} ->
	    case fdecls(to_atom(Fun), Abst) of
		[] -> error;
		Fdecls -> map(fun derive_arglist/1, Fdecls)
	    end;
	error ->
	    case beamfile(Mod) of
		{ok, BeamFile} ->
		    case get_exports(BeamFile) of
			{ok, Exports} ->
			    Funs = [{Fun0, Arity0} || {Fun0, Arity0} <- Exports,
						      Fun0 == Fun],
			    case get_forms_from_src(Mod) of
				{ok, Forms} ->
				    get_arglist_from_forms(Funs, Forms);
				_ ->
				    error
			    end;
			_ ->
			    error
		    end;
		_ ->
		    error
	    end
    end.

%% Find the {function, ...} entry for the named function in the
%% abstract syntax tree.
%% Return: {ok, {function ...}} | error
fdecls(Name, Abst) ->
    {_Exports,Forms} = Abst,
    [Fdecl || Fdecl <- Forms,
	      element(1, Fdecl) == function,
	      element(3, Fdecl) == Name].

%% Get the abstrct syntax tree for `Mod' from beam debug info.
%% Return: {ok, Abst} | error
get_abst_from_debuginfo(Mod) ->
    case beamfile(Mod) of
	{ok, Filename} ->
	    case read_abst(Filename) of
		{ok, Abst} ->
		    {ok, binary_to_term(Abst)};
		error ->
		    error
	    end;
	error ->
	    error
    end.

get_forms_from_src(Mod) ->
    case find_source(Mod) of
	{ok, SrcFName} ->
	    epp_dodger:parse_file(SrcFName);
	_ ->
	    error
    end.

%% Return the name of the beamfile for Mod.
beamfile(Mod) ->
    case code:which(Mod) of
	File when list(File) ->
	    {ok, File};
	_ ->
	    error
    end.

%% Read the abstract syntax tree from a debug info in a beamfile.
read_abst(Beam) ->
    case beam_lib:chunks(Beam, ["Abst"]) of
	{ok, {_Mod, [{"Abst", Abst}]}} when Abst /= <<>> ->
	    {ok, Abst};
	_ -> error
    end.

%% Derive a good argument list from a function declaration.
derive_arglist(Fdecl) ->
    Cs = clauses(Fdecl),
    Args = merge_args(map(fun clause_args/1, Cs)),
    map(fun to_list/1, Args).

clauses({function, _Line, _Name, _Arity, Clauses}) -> Clauses.
clause_args({clause, _Line, Args, _Guard, _Body}) ->
    map(fun argname/1, Args).

%% Return a name for an argument.
%% The result is either 'unknown' (meaning "nothing meaningful"), a
%% string (meaning a type-description), or another atom (meaning a
%% variable name).
argname({var, _Line, V}) ->
    case to_list(V) of
	"_"++_ -> unknown;
	_      -> V
    end;
argname({Type, _Line, _})          -> to_list(Type)++"()";
argname({nil, _Line})              -> "list()";
argname({cons, _Line, _Car, _Cdr}) -> "list()";
argname({match, _Line, LHS, _RHS}) -> argname(LHS);
argname(_)                         -> unknown.

%% Merge the arglists of several clauses together to create the best
%% single one we can.
merge_args(Arglists) ->
    map(fun best_arg/1, transpose(Arglists)).

%% Return the heuristically best argument description in Args.
best_arg(Args) ->
    foldl(fun best_arg/2, hd(Args), tl(Args)).

%% Return the better of two argument descriptions.
%% 'unknown' useless, type description is better, variable name is best.
best_arg(unknown, A2)          -> A2;
best_arg(A1, unknown)          -> A1;
best_arg(A1, A2) when atom(A1),atom(A2) ->
    %% ... and the longer the variable name the better
    case length(to_list(A2)) > length(to_list(A1)) of
	true -> A2;
	false -> A1
    end;
best_arg(A1, _A2) when atom(A1) -> A1;
best_arg(_A1, A2)               -> A2.

%% transpose([[1,2],[3,4],[5,6]]) -> [[1,3,5],[2,4,6]]
transpose([[]|_]) ->
    [];
transpose(L) ->
    [[hd(X) || X <- L] | transpose([tl(X) || X <- L])].

get_arglist_from_forms(Funs, Forms) ->
    map(fun({Fun, Arity}) -> src_args(Forms, to_atom(Fun), Arity) end, Funs).

src_args(_, _, 0) -> [];
src_args([{tree,function,_,{function,{tree,atom,_,Func}, Clauses}} = H | T],
	 Func, Arity) ->
    case erl_syntax_lib:analyze_function(H) of
	{_, Arity} ->
	    ArgsL0 = [Args || {tree, clause, _, {clause,Args,_,_}} <- Clauses],
	    ArgsL1 = [map(fun argname/1, Args) || Args <- ArgsL0],
	    Args = merge_args(ArgsL1),
	    map(fun to_list/1, Args);
	_ ->
	    src_args(T, Func, Arity)
    end;
src_args([_ |T], Func, Arity) ->
    src_args(T, Func, Arity).
%% if we get to [] we have a serious error

get_exports(BeamFile) ->
    case beam_lib:chunks(BeamFile, ["Atom", "ExpT"]) of
	{ok, {_, [{"Atom", AtomBin}, {"ExpT", ExpBin}]}} ->
	    Atoms = beam_disasm_atoms(AtomBin),
	    {ok, beam_disasm_exports(ExpBin, Atoms)};
	_ ->
	    error
    end.
%%-----------------------------------------------------------------------
%% BEGIN Code snitched from beam_disasm.erl; slightly modified
%%-----------------------------------------------------------------------
beam_disasm_atoms(AtomTabBin) ->
    {_NumAtoms,B} = get_int(AtomTabBin),
    disasm_atoms(B).

disasm_atoms(AtomBin) ->
    disasm_atoms(to_list(AtomBin),1).

disasm_atoms([Len|Xs],N) ->
    {AtomName,Rest} = get_atom_name(Len,Xs),
    [{N,AtomName}|disasm_atoms(Rest,N+1)];
disasm_atoms([],_) ->
    [].

get_atom_name(Len,Xs) ->
    get_atom_name(Len,Xs,[]).

get_atom_name(N,[X|Xs],RevName) when N > 0 ->
    get_atom_name(N-1,Xs,[X|RevName]);
get_atom_name(0,Xs,RevName) ->
    { lists:reverse(RevName), Xs }.

beam_disasm_exports(none, _) -> none;
beam_disasm_exports(ExpTabBin, Atoms) ->
    {_NumAtoms,B} = get_int(ExpTabBin),
    disasm_exports(B,Atoms).

disasm_exports(Bin,Atoms) ->
    resolve_exports(collect_exports(to_list(Bin)),Atoms).

collect_exports([F3,F2,F1,F0,A3,A2,A1,A0,_L3,_L2,_L1,_L0|Exps]) ->
    [{i32([F3,F2,F1,F0]),  % F = function (atom ID)
      i32([A3,A2,A1,A0])}  % A = arity (int)
%      i32([L3,L2,L1,L0])}  % L = label (int)
     |collect_exports(Exps)];
collect_exports([]) ->
    [].

resolve_exports(Exps,Atoms) ->
    [ {lookup_key(F,Atoms), A} || {F,A} <- Exps ].

lookup_key(Key,[{Key,Val}|_]) ->
    Val;
lookup_key(Key,[_|KVs]) ->
    lookup_key(Key,KVs);
lookup_key(Key,[]) ->
    exit({lookup_key,{key_not_found,Key}}).

i32([X1,X2,X3,X4]) ->
    (X1 bsl 24) bor (X2 bsl 16) bor (X3 bsl 8) bor X4.

get_int(B) ->
    {I, B1} = split_binary(B, 4),
    {i32(to_list(I)), B1}.
%%-----------------------------------------------------------------------
%% END Code snitched from beam_disasm.erl
%%-----------------------------------------------------------------------


%%-----------------------------------------------------------------
%% Call graph
%%-----------------------------------------------------------------
-define(CALL_GRAPH_SERVER, distel_call_graph).
-define(CALL_GRAPH_SERVER_OPTS, []).

rebuild_call_graph() ->
    rebuild(?CALL_GRAPH_SERVER, ?CALL_GRAPH_SERVER_OPTS).

%% Ret: [{M,F,A,Line}], M = F = binary()
who_calls(M, F, A) ->
    [{fmt("~p", [Mod]), fmt("~p", [Fun]), Aa, Line}
     || {{Mod,Fun,Aa},Line} <- calls_to({M, F, A})].

%% {M,F,A} -> [{{M,F,A},Line}]
calls_to(MFA) ->
    {ok, Calls} = xref_q(?CALL_GRAPH_SERVER, ?CALL_GRAPH_SERVER_OPTS,
			 "(XXL)(Lin)(E || ~p)", [MFA]),
    lists:flatten([[{Caller, Line} || Line <- Lines]
		   || {{{Caller,_},_}, Lines} <- Calls]).

string_format(S) -> S.
string_format(S, A) -> lists:flatten(io_lib:fwrite(S, A)).

%%-----------------------------------------------------------------
%% Support code for completion and call graph
%%-----------------------------------------------------------------

rebuild(Server, Opts) ->
    stop(Server),
    ensure_started(Server, Opts).

stop(Server) ->
    case whereis(Server) of
        undefined -> ok;
        _ -> xref:stop(Server),
             ok
    end.

xref_q(Server, Opts, Query, Args) ->
    ensure_started(Server, Opts),
    xref:q(Server, string_format(Query, Args)).

ensure_started(Server, Opts) ->
    case whereis(Server) of
	undefined ->
            xref:start(Server, Opts),
	    xref:set_default(Server, builtins, true),
            foreach(fun (Dir) -> xref:add_directory(Server, Dir) end,
                    get_code_path());
	_ ->
	    xref:update(Server),
            ok
    end.

%% FIXME: make pruning configurable, e.g. remove all otp apps
get_code_path() ->
    code:get_path().

%%-----------------------------------------------------------------
%% Call graph mode:
%% 
%% Callers of foo:bar/2
%%   + baz:doit/3
%%     foo:baz/0
%%   - baz:foo/2
%%       +  ggg:foo/2
%%          hhh:foo/0
%%
%% Keys:
%%   'ret' on a '+' line expands
%%   'ret' on a '-' line collapses
%%    ?? jump to definition in other buffer
%%-----------------------------------------------------------------
