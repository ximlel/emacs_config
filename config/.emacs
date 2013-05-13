(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search nil)
 '(ecb-options-version "2.40"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

 (setenv "HOME" "D:/tools/emacs-23.2")
 ;;(setenv "PATH" "D:/tools/emacs-23.2") ;; 会覆盖环境变量PATH
 ;;set the default file path
 (setq default-directory "D:/python_workspace")
 
;; (setq load-path(cons "~/.emacs.d/elisp" load-path))
 
 
;; 设置 load path
(setq load-path (cons "~/.emacs.d/elisp" load-path)) 

;; 在标题栏显示buffer的名字
(setq frame-title-format "emacs@%b")

;; 设置有用个人信息
(setq user-full-name "simon")
(setq user-mail-address "simon29rock@gmail.com")

;; 打开tabbar
(require 'tabbar)
(tabbar-mode)

;; 配色方案
;; 添加el的路径
(setq load-path (append load-path (list "~/.emacs.d/elisp/color-theme-6.6.0")))

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
(set-face-background 'default "black")
 ;;设置前字体色为绿色
(set-foreground-color "green")  

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
(set-language-environment 'Chinese-GB)
(set-keyboard-coding-system 'euc-cn)
(set-clipboard-coding-system 'euc-cn)
(set-terminal-coding-system 'euc-cn)
(set-buffer-file-coding-system 'euc-cn)
(set-selection-coding-system 'euc-cn)
(modify-coding-system-alist 'process "*" 'euc-cn)
(setq default-process-coding-system 
	'(euc-cn . euc-cn))
(setq-default pathname-coding-system 'euc-cn)


;; YASnippet
;; 添加el的路径
;;(setq load-path (append load-path (list "~/.emacs.d/elisp/color-theme-6.6.0")))
(setq load-path (append load-path (list "~/.emacs.d/elisp/yasnippet-0.6.1c")))
;;(add-to-list 'load-path
;;              "~/.emacs.d/elisp/yasnippet-0.6.1c")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet-0.6.1c/snippets")

;;auto-complete
(add-to-list 'load-path "~/.emacs.d/elisp")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
(ac-config-default)


;;------------------------cedet+ecb---------------------
;;--------cygwin
;(setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH"))) 
;(setq exec-path (cons "c:/cygwin/bin" exec-path)) 
;(require 'cygwin-mount) 
;(cygwin-mount-activate) 

;(add-hook 'comint-output-filter-functions                                       
;                    'shell-strip-ctrl-m nil t)                                                  
;(add-hook 'comint-output-filter-functions                                       
;                    'comint-watch-for-password-prompt nil t)                                    
;(setq explicit-shell-file-name "bash.exe")                                      
;;; For subprocesses invoked via the shell                                       
;;; (e.g., "shell -c command")                                                   
;(setq shell-file-name explicit-shell-file-name) 
;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(load-file "~/.emacs.d/install/cedet-1.0/common/cedet.el")
(require 'cedet)

(global-ede-mode 1)                      ; Enable the Project management system
;; Enable code helpers.
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu
(global-semantic-mru-bookmark-mode 1)

(add-to-list 'load-path "~/.emacs.d/install/ecb-2.40")
(require 'ecb)

;;;;;;;;;;python mode 设置
;; python-mode settings 文件关联，自动将py后缀的文件和pyhton-mode关联
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist(cons '("python" . python-mode)
interpreter-mode-alist))
;;一下为错误的 . 后面需要有空格
;;(setq auto-mode-alist (cons '("\\.py$" .python-mode) auto-mode-alist))
;;(setq interpreter-mode-alist(cons '("python" .python-mode)
;;interpreter-mode-alist))
;; path to the python interpreter, e.g.:~rw/python27/bin/python2.7
(setq py-python-command "python")		;; C-c C-c command
;;自动加载，将 python-mode 和文件 python-mode.elc关联
(autoload 'python-mode "python-mode" "Python editing mode." t)
;;;;;;;;;; start 改为打开pythone 时进入python-mode时才加载rope,pymacs,ropmacs
;;; pymacs settings
;(setq pymacs-python-command py-python-command)
;(autoload 'pymacs-load "pymacs" nil t)
;(autoload 'pymacs-eval "pymacs" nil t)
;(autoload 'pymacs-exec "pymacs" nil t)
;(autoload 'pymacs-apply "pymacs")
;(autoload 'pymacs-call "pymacs")
;(require 'pycomplete)
;;;Ropmacs
;(require 'pymacs)
;(pymacs-load "ropemacs" "rope-")
;(setq ropemacs-enable-autoimport t)
(eval-after-load "python-mode"
  '(progn
     (setq pymacs-python-command py-python-command)
     (autoload 'pymacs-apply "pymacs")
     (autoload 'pymacs-call "pymacs")
     (autoload 'pymacs-eval "pymacs" nil t)
     (autoload 'pymacs-exec "pymacs" nil t)
     (autoload 'pymacs-load "pymacs" nil t)
     (require 'pycomplete)
     (require 'pymacs)
     (message  "loading repomacs")
     (pymacs-load "ropemacs" "rope-")
     (setq ropemacs-enable-autoimport t)))
;;;;;;;;;; start 改为打开pythone 时进入python-mode时才加载rope,pymacs,ropmacs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;代码折叠
;需要cedet
;;http://blog.csdn.net/pfanaya/article/details/6939310
;;;代码折叠
;(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1)
;;折叠和打开整个buffer的所有代码
(define-key semantic-tag-folding-mode-map (kbd "C--") 'semantic-tag-folding-fold-all)
(define-key semantic-tag-folding-mode-map (kbd "C-=") 'semantic-tag-folding-show-all)
;;折叠和打开单个buffer的所有代码
(define-key semantic-tag-folding-mode-map (kbd "C-_") 'semantic-tag-folding-fold-block)
(define-key semantic-tag-folding-mode-map (kbd "C-+") 'semantic-tag-folding-show-block)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(add-hook 'python-mode-hook 'my-python-hook)
;;(defun py-outline-level ()
;;"This is so that `current-column` DTRT in otherwise-hidden text"
;;;; from ada-mode.el
;;(let (buffer-invisibility-spec)
;;    (save-excursion
;;      (skip-chars-forward "\t ")
;;      (current-column))))
;;; this fragment originally came from the web somewhere, but the outline-regexp
;;; was horribly broken and is broken in all instances of this code floating
;;; around. Finally fixed by Charl P. Botha <<a href="http://cpbotha.net/">http://cpbotha.net/</a>>
;;(defun my-python-hook ()
;;(setq outline-regexp "[^ \t\n]\\|[ \t]*\\(def[ \t]+\\|class[ \t]+\\)")
;;; enable our level computation
;;(setq outline-level 'py-outline-level)
;;; do not use their \C-c@ prefix, too hard to type. Note this overides
;;;some python mode bindings
;;(setq outline-minor-mode-prefix "\C-c")
;;; turn on outline mode
;;(outline-minor-mode t)
;;; initially hide all but the headers
;;(hide-body)
;;(show-paren-mode 1)
;;)
				 
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
    ;;; Maximum Windows Frame
    (w32-maximize-frame)
	(setq initial-frame-alist '((top . 0) (left . 0) (width . 1600) (height . 900)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; 启动最大化窗口设置 - END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/.emacs.d/elisp/key.el")