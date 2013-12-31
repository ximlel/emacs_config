;;http://blog.163.com/sea_haitao/blog/static/7756216201282954454934/
;;;;;;;;;;erlang mode 设置
;; erlang-mode settings 文件关联，自动将py后缀的文件和erlang-mode关联
;; Erlang mode
;linux
(setq load-path (cons  "/usr/local/erlang/lib/erlang/lib/tools-2.6.6/emacs" load-path))
(setq erlang-root-dir "/usr/local/erlang")
(setq exec-path (cons "/usr/local/erlang/bin" exec-path))
(setq erlang-man-root-dir "/usr/local/erlang/man")  // 解压缩文件 
;windows
;(setq load-path (cons  "C:/Program Files/erl5.10.3/lib/tools-2.6.12/emacs" load-path))
;(setq erlang-root-dir "C:/Program Files/erl5.10.3")
;(setq exec-path (cons "C:/Program Files/erl5.10.3/bin" exec-path))
;(setq erlang-man-root-dir "/usr/local/erlang/man")  // 解压缩文件 
(require 'erlang-start)
;(setq auto-mode-alist (cons '("\\.erl$" . erlang-mode) auto-mode-alist))
;(setq interpreter-mode-alist(cons '("erlang" . erlang-mode)
;interpreter-mode-alist))
; 关联erl
(add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl?$" . erlang-mode))
(require 'erlang-flymake)
     (let ((distel-dir "~/.emacs.d/elisp/distel_090306/"))
     (unless (member distel-dir load-path)
     (setq load-path (append load-path (list distel-dir)))))
     (require 'distel)
     (distel-setup)

;; Some Erlang customizations
(add-hook 'erlang-mode-hook
  (lambda ()
  ;; when starting an Erlang shell in Emacs, default in the node name
    (setq inferior-erlang-machine-options '("-sname" "emacs"))
    ;; add Erlang functions to an imenu menu
    (imenu-add-to-menubar "imenu")))
;; A number of the erlang-extended-mode key bindings are useful in the shell too
(defconst distel-shell-keys
  '(("\C-\M-i"   erl-complete)
    ("\M-?"      erl-complete) 
    ("\M-."      erl-find-source-under-point)
    ("\M-,"      erl-find-source-unwind) 
    ("\M-*"      erl-find-source-unwind) 
    )
  "Additional keys to bind when in Erlang shell.")
(add-hook 'erlang-shell-mode-hook
   (lambda ()
     ;; add some Distel bindings to the Erlang shell
     (dolist (spec distel-shell-keys)
       (define-key erlang-shell-mode-map (car spec) (cadr spec)))))

