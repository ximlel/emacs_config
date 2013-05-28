
;;F5显示/隐藏工具栏 方便调试
(global-set-key [f5] 'tool-bar-mode)
;;ctrl-F5显示/隐藏菜单栏 ;; M-x menu-bar-open
(global-set-key [C-f5] 'menu-bar-mode)
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
	
;;f3为查找字符串,alt+f3关闭当前缓冲区
(global-set-key [f3] 'grep-find)
;;==================ecb的配置=================================
;;为了ecb窗口的切换
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)
;;隐藏和显示ecb窗口
(global-set-key [f11] 'ecb-hide-ecb-windows)
(global-set-key [S-f11] 'ecb-show-ecb-windows)