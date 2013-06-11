;;(global-set-key (kbd "C-x q") 'switch-major-mode)
;;(global-set-key (kbd "C-x m") 'get-mode-name)
;;(define-key global-map (kbd "C-x M-c") 'describe-char)
;;(define-key global-map (kbd "C-x M-d") 'dos2unix)
;;("C-x M-k" Info-goto-emacs-key-command-node)
;;   ("C-x ESC ESC" repeat-complex-command-sb)))

;; 一些基本的小函数
(require 'ahei-misc)
;; 利用`eval-after-load'加快启动速度的库
;; 用eval-after-load避免不必要的elisp包的加载
;; http://emacser.com/eval-after-load.htm
(require 'eval-after-load)

;; ==============配色方案 包含所有的项目
;(load "~/.emacs.d/elisp/si-color-theme/color-theme-molokai.el")
;(load "~/.emacs.d/elisp/si-color-theme/color-theme-arjen.el")
;(require 'color-theme)
;(eval-after-load "color-theme"
;'(progn
;(color-theme-initialize)
;(color-theme-gnome2))) ;;what ever you like, I like color-theme-gnome2
;(color-theme-midnight)))
;(color-theme-arjen)))
;(color-theme-molokai)))
;(color-theme-robin-hood)))
;(color-theme-initialize)
;(color-theme-molokai)
;; ahei env
(require 'ahei-misc)
;; color theme Emacs主题,很多face文件
(require 'color-theme-settings)         ;;调色功能
(require 'ahei-face)                    ;;色彩模式定义
(require 'color-theme-ahei)             ;;基本色彩定义
(require 'face-settings)                ;;基本色彩定义

;; 高亮当前行
;(require 'hl-line-settings)

;;设置背景色为 黑色
;(set-face-background 'default "black")
;;设置前字体色为绿色
;(set-foreground-color "green")  
;; ==============配色方案

;; 各种语言开发方面的设置,这个设置牵涉到太多配置....
(require 'dev-settings)

;; 在buffer中方便的查找字符串: color-moccur
(require 'moccur-settings)
;; Emacs超强的增量搜索Isearch配置
(require 'isearch-settings)

;; 把文件或buffer彩色输出成html
(require 'htmlize)

;; Emacs可以做为一个server, 然后用emacsclient连接这个server,
;; 无需再打开两个Emacs
(require 'emacs-server-settings)

;; 简写模式
(setq-default abbrev-mode t)
(setq save-abbrevs nil)

;; 可以为重名的buffer在前面加上其父目录的名字来让buffer的名字区分开来，而不是单纯的加一个没有太多意义的序号
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; 以目录形式显示linkd文档
;;(require 'linkd-settings)

;; Emacs的超强文件管理器
(require 'dired-settings)

;; 方便的切换major mode
(defvar switch-major-mode-last-mode nil)

(defun major-mode-heuristic (symbol)
  (and (fboundp symbol)
       (string-match ".*-mode$" (symbol-name symbol))))

(defun switch-major-mode (mode)
  "切换major mode"
  (interactive
   (let ((fn switch-major-mode-last-mode) val)
     (setq val
           (completing-read
            (if fn (format "切换major-mode为(缺省为%s): " fn) "切换major mode为: ")
            obarray 'major-mode-heuristic t nil nil (symbol-name fn)))
     (list (intern val))))
  (let ((last-mode major-mode))
    (funcall mode)
    (setq switch-major-mode-last-mode last-mode)))
(global-set-key (kbd "C-x q") 'switch-major-mode)

(defun get-mode-name ()
  "显示`major-mode'及`mode-name'"
  (interactive)
  (message "major-mode为%s, mode-name为%s" major-mode mode-name))
(global-set-key (kbd "C-x m") 'get-mode-name)

;; 增加更丰富的高亮
(require 'generic-x)

;; 在Emacs里面使用shell
(require 'term-settings)
;;(require 'multi-term-settings)	;;影响python

(define-key global-map (kbd "C-x M-c") 'describe-char)

(defun dos2unix ()
  "dos2unix on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'unix))

(defun unix2dos ()
  "unix2dos on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'dos))

(define-key global-map (kbd "C-x M-d") 'dos2unix)

(define-key-list
 global-map
 `(("C-x M-k" Info-goto-emacs-key-command-node)
   ("C-x ESC ESC" repeat-complex-command-sb)))

;; 关闭buffer的时候, 如果该buffer有对应的进程存在, 不提示, 烦
(delq 'process-kill-buffer-query-function kill-buffer-query-functions)