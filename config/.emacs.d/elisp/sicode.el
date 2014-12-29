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
(require 'cc-mode)
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)

(defun my-c-mode-common-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  ;;; hungry-delete and auto-newline
;;  (c-toggle-auto-hungry-state 1)
  (define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)
 (define-key c-mode-base-map [(return)] 'newline-and-indent)

  (define-key c-mode-base-map [(meta \`)] 'c-indent-command)
;;  (define-key c-mode-base-map [(tab)] 'hippie-expand)
;;  (define-key c-mode-base-map [(tab)] 'my-indent-or-complete)
;;  (define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
  ;;预处理设置
  (setq c-macro-shrink-window-flag t)
  (setq c-macro-preprocessor "cpp")
  (setq c-macro-cppflags " ")
  (setq c-macro-prompt-flag t)
  (setq hs-minor-mode t)
  (setq abbrev-mode t)
)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(defun my-c++-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  (c-set-style "stroustrup")
;;  (define-key c++-mode-map [f3] 'replace-regexp)
)

;;配置Semantic搜索范围
(setq semanticdb-project-roots
	  (list
	   (expand-file-name "/")))
;;自定义补全命令，如果单词在中间就补全，否则就tab
(defun my-indent-or-complete()
  (interactive)
  (if (looking-at "\\>")
	  (hippie-expand nil)
	  (indent-for-tab-command))
  )
;;补全快捷键，ctrl+tab用senator补全，不显示列表
;;alt+/补全，显示列表让选择
(global-set-key [(control tab)] 'my-indent-or-complete)
(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
(autoload 'senator-try-expand-semantic "senator")
(setq hippie-expand-try-functions-list
	  '(
		senator-try-expand-semantic
		try-expand-dabbrev
		try-expand-dabbrev-visible
		try-expand-dabbrev-all-buffers
		try-expand-dabbrev-from-kill
		try-expand-list
		try-expand-list-all-buffers
		try-expand-line
		try-expand-line-all-buffers
		try-complete-file-name-partially
		try-complete-file-name
		try-expand-whole-kill
		)
	  )
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
