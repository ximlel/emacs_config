;;https://linuxtoy.org/archives/emacs-eshell.html
(load-file "~/.emacs.d/elisp/eshell-color-theme.el")
;(require 'eshell-user-keyel) ;some setting, but no use now
(add-hook 'eshell-mode-hook (lambda()
           (outline-minor-mode 1)
           (color-theme-eshell)
;           (color-theme-my-eshell)
           (setq outline-regexp "^[^#$\n]* [#>]+ "
                 scroll-margin 0
                 eshell-scroll-to-bottom-on-output t
                 eshell-scroll-show-maximum-output t)
           (add-to-list 'eshell-output-filter-functions 
                        'eshell-postoutput-scroll-to-bottom)
;           (def-key-s eshell-mode-map 
;             "<up>"     'eshell-previous-matching-input-from-input
;             "<down>"   'eshell-next-matching-input-from-input
;             "<tab>"    'user-tab
;             "<return>" 'user-ret
;              "SPC"      'user-spc
;)
))

(setq
      eshell-save-history-on-exit   t
      eshell-history-size           512
      eshell-hist-ignoredups        t
      eshell-cmpl-ignore-case       t
      eshell-cp-interactive-query   t
      eshell-ln-interactive-query   t
      eshell-mv-interactive-query   t
      eshell-rm-interactive-query   t
      eshell-mv-overwrite-files     nil
      ;; aliases-file 里面不能有多余的空行，否则会报正则表达式错误
;      eshell-aliases-file       (expand-file-name "_eshell/eshell-alias" init-dir)

      eshell-highlight-prompt   t
      ;; 提示符设置，下面两项必须对应起来，
      ;; 否则会报 read-only，并且不能补全什么的
      eshell-prompt-regexp      "^[^#$\n]* [#>]+ "
      eshell-prompt-function    (lambda nil
                                  (concat
                                   (abbreviate-file-name
                                    (eshell/pwd))
                                   (if
                                       (=
                                        (user-uid)
                                        0)
                                       " # " " >>> ")))
)

(add-hook 'eshell-load-hook
          (lambda()(setq last-command-start-time (time-to-seconds))))
(add-hook 'eshell-pre-command-hook
          (lambda()(setq last-command-start-time (time-to-seconds))))
(add-hook 'eshell-before-prompt-hook
          (lambda()
              (message "spend %g seconds"
                       (- (time-to-seconds) last-command-start-time))))

(defalias 'ff 'find-file)
;;(defalias 'ee (lambda()(find-file (expand-file-name "44eshell.el" init-dir))))
;;(defalias 'aa (lambda()(find-file eshell-aliases-file)))
;;(defalias 'rr (lambda()(find-file (expand-file-name "qref.org" sand-box))))
(defalias 'ss  'shell-command-to-string)

(defvar ac-source-eshell-pcomplete
  '((candidates . (pcomplete-completions))))
(defun ac-complete-eshell-pcomplete ()
  (interactive)
  (auto-complete '(ac-source-eshell-pcomplete)))
;; 自动开启 ac-mode
;; 需要 (global-auto-complete-mode 1)
(require 'auto-complete-config)
(add-to-list 'ac-modes 'eshell-mode)
(setq ac-sources '(ac-source-eshell-pcomplete
                   ;; ac-source-files-in-current-dir
                   ;; ac-source-filename
                   ;; ac-source-abbrev
                   ;; ac-source-words-in-buffer
                   ;; ac-source-imenu
))
