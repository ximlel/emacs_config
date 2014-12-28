;;==============================================================
;;gdb-UI配置
;;==============================================================
(setq gdb-many-windows t)

;; YASnippet
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet-0.6.1c/snippets")

;; windows config  下面的自动补齐更好alt+/
;;auto-complete  delete by simon have problem in windows when edit c++
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
(ac-config-default)

;;cedet
(require 'cedet)
(global-ede-mode 1)                      ; Enable the Project management system
;; Enable code helpers.
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu
(global-semantic-mru-bookmark-mode 1)
(semantic-load-enable-minimum-features)
(semantic-load-enable-semantic-debugging-helpers)
(global-semantic-tag-folding-mode 1)

;;ecb
(require 'ecb)
;;==============================================================
;; clang 
;;==============================================================
(require 'auto-complete-clang)
(setq ac-clang-auto-save t)
;;(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)
;;(ac-set-trigger-key "TAB")    
;;(define-key ac-mode-map  [(control tab)] 'auto-complete)    
;; 提示快捷键为 M-/  
;;(define-key ac-mode-map  (kbd "M-/") 'auto-complete)  
(defun my-ac-config ()
  ;;$ echo "" | g++ -v -x c++ -E -  to show the include dir
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
")))  
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))  
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)  
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)  
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)  
  (add-hook 'css-mode-hook 'ac-css-mode-setup)  
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)  
  (global-auto-complete-mode t))  
(defun my-ac-cc-mode-setup ()  
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))  
(add-hook 'c++-mode-hook 'my-ac-cc-mode-setup)  
;; ac-source-gtags  
(my-ac-config)
 ;;=========

;; 代码折叠 使用cedet的
;(load-library "hideshow")
;(add-hook 'java-mode-hook 'hs-minor-mode)
;(add-hook 'perl-mode-hook 'hs-minor-mode)
;(add-hook 'php-mode-hook 'hs-minor-mode)
;(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)

;; 语法加亮
;; add these lines if you like color-based syntax highlighting
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;==========================================================
;;加载cscope
;;==========================================================
(require 'xcscope)
;;==========================================================
;;加载git-emacs
;;==========================================================
(require 'git-emacs)
