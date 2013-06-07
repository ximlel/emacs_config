
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