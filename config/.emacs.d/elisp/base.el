
;; 设置工作目录
(setq default-directory "D:/python_workspace")

;; 在标题栏显示buffer的名字
(setq frame-title-format "emacs@%b")

;; 设置有用个人信息
(setq user-full-name "simon")
(setq user-mail-address "simon29rock@gmail.com")

;; 打开tabbar
(require 'tabbar)
(tabbar-mode)

;; 配色方案
(require 'color-theme)
(eval-after-load "color-theme"
'(progn
(color-theme-initialize)
(color-theme-gnome2))) ;;what ever you like, I like color-theme-gnome2
;(color-theme-robin-hood)))

;; 关闭提示音
(setq visible-bell t)

;; 简化工具条
(tool-bar-mode -1)

;; 显示时间
(display-time)

;; 显示行号
(setq column-number-mode t)

;;行号
(global-linum-mode t)

;; 显示匹配的括号
(show-paren-mode t)

;; 加大kill ring，防止出错后无法回滚文档
(setq kill-ring-max 100)

;; 把fill-column设为60
(setq default-fill-column 60)

;; 不使用tab缩进
;;;;; 设置tab为4个空格的宽度 
(setq c-basic-offset 4) 
(setq-default indent-tabs-mode nil) 
(setq default-tab-width 4) 
(setq tab-width 4) 
(setq tab-stop-list ()) 
(loop for x downfrom 40 to 1 do 
(setq tab-stop-list (cons (* x 4) tab-stop-list))) 

;;(setq-default indent-tabs-mode nil)
;;(setq indent-tabs-mode nil)
;;(setq default-tab-width 4)   
;;(setq tab-width 4)
;; 询问时的 yes or no 改为 y/n，减少输入量
(fset 'yes-or-no-p 'y-or-n-p)

;; 设置sentence-end可以识别中文标点
(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)

;; 可以递归使用minibuffer
(setq enable-recursive-minibuffers t)

;; 防止页面滚动时跳动，scroll-margin 3
(setq scroll-margin 3
      scroll-conservatively 10000)

;; 把默认的major mode设置为 text-mode
(setq default-major-mode 'text-mode)

;; 括号匹配时显示另外一边的括号，而不是跳到另一个括号
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;; 光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线
(mouse-avoidance-mode 'animate)
;; 设置光标为竖线
(setq-default cursor-type 'bar)
;; 设置光标为方块
;;(setq-default cursor-type 'box)

;; 使用 C-k 删除整行
(setq-default kill-whole-line t)

;; 让emacs可以直接打开和显示图片
(auto-image-file-mode)

;; 语法加亮
;; add these lines if you like color-based syntax highlighting
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;;设置背景色为 黑色
;(set-face-background 'default "black")
;;设置前字体色为绿色
;(set-foreground-color "green")  

;; 高亮显示要拷贝的区域
(transient-mark-mode t)

;; 把一些默认禁用的功能打开
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;; 设置备份时的版本控制
;; 所有的备份文件转移到~/backups目录下
(setq backup-directory-alist (quote (("." . "~/backups"))))
(setq backup-directory-alist '(("." . "~/backups")))
(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq kept-old-versions 2)
(setq dired-kept-versions 1)
(setq backup-by-copying t)
;; Emacs 中，改变文件时，默认都会产生备份文件(以 ~ 结尾的文件)。可以完全去掉
;; (并不可取)，也可以制定备份的方式。这里采用的是，把所有的文件备份都放在一
;; 个固定的地方("~/var/tmp")。对于每个备份文件，保留最原始的两个版本和最新的
;; 五个版本。并且备份的时候，备份文件是复本，而不是原件
;; 如果不想自动备份文件，可以把上面的配置注释
;; 打开下面的配置：
;; 不自动生成备份文件
;; (setq-default make-backup-files nil)

;; 让 dired 可以递归地拷贝和删除目录
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

;; 代码折叠
(load-library "hideshow")
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'php-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)

;; 中文配置
;(set-language-environment 'Chinese-GB)
;(set-keyboard-coding-system 'euc-cn)
;(set-clipboard-coding-system 'euc-cn)
;;(set-terminal-coding-system 'euc-cn)
;(set-buffer-file-coding-system 'euc-cn)
;;(set-selection-coding-system 'euc-cn)
;(modify-coding-system-alist 'process "*" 'euc-cn)
;(setq default-process-coding-system 
;	'(euc-cn . euc-cn))
;===
;(setq-default pathname-coding-system 'euc-cn)
;(setq current-language-environment "UTF-8")
;(setq default-input-method "chinese-py")
;(setq locale-coding-system 'utf-8)
;(prefer-coding-system 'utf-8)
;==
(set-language-environment 'UTF-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 启动最大化窗口设置 - START    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (defun w32-restore-frame ()
    "Restore a minimized frame"
    (interactive)
    (w32-send-sys-command 61728))
    (defun w32-maximize-frame ()
    "Maximize the current frame"
    (interactive)
    (w32-send-sys-command 61488))
    ;;;; Maximum Windows Frame
    (w32-maximize-frame)
	;;(setq initial-frame-alist '((top . 0) (left . 0) (width . 1600) (height . 900)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; 启动最大化窗口设置 - END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;