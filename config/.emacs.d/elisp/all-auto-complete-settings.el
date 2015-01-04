(require 'wttr-utils)
(wttr/prepend-to-exec-path "~/bin/clang")
;; YASnippet
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet-0.6.1c/snippets")

;; windows config  下面的自动补齐更好alt+/
;;auto-complete  delete by simon have problem in windows when edit c++
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete-1.3.1/dict")
(ac-config-default)

;; use pos-tip, which is better than native popup
;; 
;; NOTE:
;; If we do not require pos-tip explicitly, this feature will not be
;; triggered, even we set `ac-quick-help-prefer-pos-tip' to t, which
;; is already the default value. We can see the implementation of
;; `ac-quick-help-use-pos-tip-p' to find the reason.
(require 'pos-tip)
(setq ac-quick-help-prefer-pos-tip t)   ;default is t

;; Quick help will appear at the side of completion menu, so you can
;; easily see the help.
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 1.0)

;; behavior of completion by TAB will be changed as a behavior of
;; completion by RET
;;  - After selecting candidates, TAB will behave as RET
;;  - TAB will behave as RET only on candidate remains
(setq ac-dwim t)                        

;; give a key to trigger ac when it is not automatically triggered
(ac-set-trigger-key "<C-return>")

;; make del also trigger the ac
; (setq ac-trigger-commands (cons 'backward-delete-char-untabify ac-trigger-commands))

;; use fuzzy mode, its interesting
(setq ac-fuzzy-enable t)

;; by default we use 3 to start ac
(setq ac-auto-start 3)

;; auto complete clang
(if wttr/os:windowsp 
    (wttr/prepend-to-exec-path "~/.emacs.d/exec_bin/clang"))

    (global-auto-complete-mode t) 
;; 使用Ctrl+enter按键触发自动补全  
;(define-key ac-mode-map  [(control return)] 'auto-complete)  
;; 自动触发
;(setq ac-clang-auto-save t)  
(setq ac-auto-start t)

;; clang
(require 'auto-complete-clang)

;; my-ac-config 
(defun my-ac-config () 
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers)) 
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup) 
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup) 
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup) 
  (add-hook 'css-mode-hook 'ac-css-mode-setup) 
  (add-hook 'auto-complete-mode-hook 'ac-common-setup) 
  (global-auto-complete-mode t)) 
(my-ac-config)
(defun wttr/cc-mode:auto-complete-setup ()
  (setq-default indent-tabs-mode nil)
  (setq tab-width 4)
  (make-local-variable 'ac-auto-start)
  (setq ac-auto-start t)              ;auto complete using clang is CPU sensitive
  ;(setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet))))  ;; change by simon, if not will can get info when input code, and only get info after "."

;(add-hook 'c-mode-hook 'wttr/cc-mode:auto-complete-setup)
;(add-hook 'c++-mode-hook 'wttr/cc-mode:auto-complete-setup)
(add-hook 'c-mode-common-hook 'wttr/cc-mode:auto-complete-setup)  
;; system specific setting
(if wttr/os:windowsp
    (setq ac-clang-flags  (list   
                             "-ID:/mingw/lib/gcc/mingw32/4.8.1/include/c++"  
                             "-ID:/mingw/lib/gcc/mingw32/4.8.1/include/c++/mingw32"
                             "-ID:/mingw/lib/gcc/mingw32/4.8.1/include/c++/backward"
                             "-ID:/mingw/lib/gcc/mingw32/4.8.1/include"  
                             "-ID:/mingw/include"
                             "-ID:/mingw/lib/gcc/mingw32/4.8.1/include-fixed"
                             "-ID:/mingw/mingw32/include"
                             "-D__MSVCRT__=")))
;;linux
(if wttr/os:linuxp
    (setq ac-clang-flags  
        (mapcar(lambda (item)(concat "-I" item))  
               (split-string  
                    "  
                    /usr/lib/gcc/x86_64-redhat-linux/4.7.2/../../../../include/c++/4.7.2
                    /usr/lib/gcc/x86_64-redhat-linux/4.7.2/../../../../include/c++/4.7.2/x86_64-redhat-linux
                    /usr/lib/gcc/x86_64-redhat-linux/4.7.2/../../../../include/c++/4.7.2/backward
                    /usr/lib/gcc/x86_64-redhat-linux/4.7.2/include
                    /usr/local/include
                    /usr/include
                    "))))

;; reference !!!
;; system specific setting
;(let ((extra-clang-flags (cond
;                          (wttr/host:MSWSp
;                           (list "-IC:/MinGW/include"
;                                 "-IC:/MinGW/lib/gcc/mingw32/4.6.1/include"
;                                 "-IC:/MinGW/lib/gcc/mingw32/4.6.1/include/c++"
;                                 "-IC:/MinGW/lib/gcc/mingw32/4.6.1/include/c++/mingw32"
;                                 "-D__MSVCRT__="))
;                          (wttr/host:HOMEp
;                           (list "-IC:/MinGW/include"
;                                 "-IC:/MinGW/include/c++/3.4.5"
;                                 "-IC:/MinGW/lib/gcc/mingw32/3.4.5/include"
;                                 "-IC:/MinGW/include/c++/3.4.5/mingw32"
;                                 "-D__MSVCRT__"))
;                          (t
;                           nil))))
;  (setq ac-clang-flags extra-clang-flags))
;(when (string-equal (system-name) "WINTERTTR-WS")
;  (setq ac-clang-flags (mapcar (lambda (x) (concat "-I" x)) 
;                               (list "D:/src/zephyr/perf/OTHERS/STDCPP/INCLUDE"
;                                     "D:/src/zephyr/perf/TOOLS/PUBLIC/ext/crt80/inc"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/OAK/INC"
;                                     "D:/src/zephyr/perf/PUBLIC/COMMON/SDK/INC")))
;  (setq ac-clang-flags (cons "-D_WIN32_WCE" ac-clang-flags)))


;; hippie expand
;;(require 'hippie-expand-settings)

;; 自动补全
;;(require 'auto-complete-settings)

;; (require 'company-settings)

;; 自动插入一些文件模板,用template
;;(require 'template-settings)

;; 自动插入一些文件模板
;;(require 'auto-insert-settings)

;; 超强的snippet
;;(require 'yasnippet-settings)

(provide 'all-auto-complete-settings)
