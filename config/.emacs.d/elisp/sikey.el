(global-unset-key (kbd "C-z")) ; for xwindows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;代码折叠
;需要cedet
;;http://blog.csdn.net/pfanaya/article/details/6939310
;;;代码折叠
;(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1) ; for xwindows
;;折叠和打开整个buffer的所有代码
(define-key semantic-tag-folding-mode-map (kbd "C--") 'semantic-tag-folding-fold-all) ; for xwindows
(define-key semantic-tag-folding-mode-map (kbd "C-=") 'semantic-tag-folding-show-all) ; for xwindows
;;折叠和打开单个buffer的所有代码
(define-key semantic-tag-folding-mode-map (kbd "C-_") 'semantic-tag-folding-fold-block) ; for xwindows
(define-key semantic-tag-folding-mode-map (kbd "C-+") 'semantic-tag-folding-show-block) ; for xwindows

(global-set-key [f1] 'manual-entry)
(global-set-key [C-f1] 'info )
(require 'sr-speedbar)
(global-set-key [C-f2] 'sr-speedbar-open )
;;f3为查找字符串,alt+f3关闭当前缓冲区
(global-set-key [f3] 'grep-find)
(global-set-key [M-f3] 'kill-this-buffer)

;;F5显示/隐藏工具栏 方便调试
(global-set-key [f5] 'tool-bar-mode) ; for xwindows
;(global-set-key [f4] 'ska-point-to-register) ;for console
;(global-set-key [f5] 'ska-jump-to-register)  ;for console


;;ctrl-F5显示/隐藏菜单栏 ;; M-x menu-bar-open
(global-set-key [C-f5] 'menu-bar-mode)
(global-set-key [f6] 'gdb)

;;  C-f7, 设置编译命令; f7, 保存所有文件然后编译当前窗口文件
(defun du-onekey-compile ()
  "Save buffers and start compile"
  (interactive)
  (save-some-buffers t)
  (switch-to-buffer-other-window "*compilation*")
  (compile compile-command))
  
(setq-default compile-command "make")    
(global-set-key [C-f7] 'compile)
 (global-set-key [f7] 'du-onekey-compile)

;;目的是开一个shell的小buffer，用于更方便地测试程序(也就是运行程序了)，我经常会用到。
;;f8就是另开一个buffer然后打开shell，C-f8则是在当前的buffer打开shell,shift+f8清空eshell
(defun open-eshell-other-buffer ()
  "Open eshell in other buffer"
  (interactive)
  (split-window-vertically)
  (eshell))
(defun my-eshell-clear-buffer ()
  "Eshell clear buffer."
  (interactive)
  (let ((eshell-buffer-maximum-lines 0))
    (eshell-truncate-buffer)))
(global-set-key [(f8)] 'open-eshell-other-buffer)
(global-set-key [C-f8] 'eshell)
(global-set-key [S-f8] 'my-eshell-clear-buffer)

;;设置[C-f9]为调用dired命令
(global-set-key [C-f9] 'dired)
(global-set-key [f9] 'other-window);f9在其他窗口之间旋转

;;F12调到函数定义
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [C-f12] 'list-bookmarks)
;;shift-f12跳回去
(global-set-key [S-f12]
	(lambda ()
	(interactive)
	(if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
	(error "Semantic Bookmark ring is currently empty"))
	(let* ((ring (oref semantic-mru-bookmark-ring ring))
	(alist (semantic-mrub-ring-to-assoc-list ring))
	(first (cdr (car alist))))
	(if (semantic-equivalent-tag-p (oref first tag)
	(semantic-current-tag))
	(setq frist (cdr (car (cdr alist)))))
	(semantic-mrub-switch-tags first))))
	
;;==================ecb的配置=================================
;;为了ecb窗口的切换
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)
;;隐藏和显示ecb窗口
(global-set-key [f11] 'ecb-hide-ecb-windows)
(global-set-key [S-f11] 'ecb-show-ecb-windows)
