;;==============================================================
;;gdb-UI配置
;;==============================================================
(setq gdb-many-windows t)

(require 'all-auto-complete-settings)

;;cedet
(require 'cedet)
(global-ede-mode 1)                      ; Enable the Project management system
;(global-srecode-minor-mode 1)            ; Enable template insertion menu    // remove by simon
;(global-semantic-mru-bookmark-mode 1)    // remvoe by simon
;(semantic-load-enable-minimum-features)  // remove by simon
;(semantic-load-enable-semantic-debugging-helpers) // remove by simon
;(global-semantic-tag-folding-mode 1)     // remove by simon

;;ecb
;(require 'ecb)   // remvoe by simon
;;==============================================================
;;cc mode 自动提示 alt+/
;;==============================================================
;(require 'semantic-settings)  // remove
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
(setq cscope-do-not-update-database t) ;; cahnge by simon 2015, make auto update database disable.
;;==========================================================
;;加载git-emacs
;;==========================================================
(require 'git-emacs)
