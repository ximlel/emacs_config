;;==============================================================
;;gdb-UI配置
;;==============================================================
(setq gdb-many-windows t)

(require 'all-auto-complete-settings)

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
;;cc mode 自动提示 alt+/
;;==============================================================
(require 'semantic-settings)
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
