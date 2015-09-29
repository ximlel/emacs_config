(require 'wttr-utils)
(require 'cedet)

;; Enabling Semantic (code-parsing, smart completion) feature, Select one of the following:
;;最低要求
;(semantic-load-enable-minimum-features)
;;主要是加了一个imenu菜单(不过这个菜单在windows和mac上都显示不出来)
(semantic-load-enable-code-helpers)
;;加入了一些用处不大的功能，比如在第一行显示当前的函数等（这个命令已经不建议使用了）
;; (semantic-load-enable-guady-code-helpers)
;;加了在mode line显示当前函数名的功能，也没多大用
;;(semantic-load-enable-excessive-code-helpers)
;;用于调试 semantic本身
;;(semantic-load-enable-semantic-debugging-helpers)

;; gcc setup
(require 'semantic-gcc)

(defun si-semantic-C++-hook()
;;调用senator的分析结果直接补全，不弹出菜单
;; (global-set-key [(control tab)] 'senator-complete-symbol);
;;也是调用senator，不过会弹一个选择菜单
;; (global-set-key [(control tab)] 'senator-completion-menu-popup) ;; use C-c , SPC instead
;;是调用semantic的分析结果智能补全，不弹出菜单
;; (global-set-key [(control tab)] 'semantic-ia-complete-symbol)
;;也是调用semantic的结果，不过会弹出一个选择菜单
;(local-set-key [(meta ?/)] 'semantic-complete-analyze-inline) ;for console
(local-set-key [(meta ?/)] 'semantic-ia-complete-symbol-menu)  ; for xwindows
;(local-set-key [(control tab)] 'semantic-ia-complete-symbol-menu)

;(local-set-key "\C-c>" ‘semantic-complete-analyze-inline)
;(local-set-key (kbd "M-/") ‘semantic-complete-analyze-inline)
;(local-set-key "\C-cp" ‘semantic-analyze-proto-impl-toggle)
;(local-set-key "\C-cd" ‘semantic-ia-fast-jump)
;(local-set-key "\C-cr" ‘semantic-symref-symbol)
;(local-set-key "\C-cR" ‘semantic-symref)
; use clang default now.
;(local-set-key "." 'semantic-complete-self-insert)
;(local-set-key ">" 'semantic-complete-self-insert)
  )

(add-hook 'c-mode-common-hook 'si-semantic-C++-hook)
;(autoload 'senator-try-expand-semantic "senator")               ;优先调用了senator的分析结果
;; semantic 检索范围
(if wttr/os:linuxp
(setq semanticdb-project-roots
      (list
       (expand-file-name "/"))))
(if wttr/os:windowsp
    (setq semanticdb-project-roots
      (list
       (expand-file-name "D:/MinGW"))))
;;设置semantic cache path
(setq semanticdb-default-save-directory "~/.emacs.d/")
;; cannot work on windows for std(eg. vector)
;; http://stackoverflow.com/questions/2434499/emacs-c-code-completion-for-vectors
;; This is a known problem with the Semantic analyzer. I currently cannot deal with Template Specialization, 
;; which is used in the gcc STL (your problem stems from such a specialization in allocator.h). This has 
;; been discussed on the mailing list:
;; http://thread.gmane.org/gmane.emacs.semantic/2137/focus=2147

(require 'semantic-decorate-include)
(require 'semanticdb)
(require 'semantic-ia)
(require 'semantic-gcc)
(global-srecode-minor-mode 1)
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project local unloaded system recursive))
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(local unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(project local unloaded system recursive))
;(semanticdb-enable-gnu-global-databases 'c-mode)
;(semanticdb-enable-gnu-global-databases 'c++-mode)
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(defconst cedet-win32-include-dirs
  (list           "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++"
                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32"
                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/backward"
                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include"
                  "D:/MinGW/include"
                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include-fixed"
                  "D:/MinGW/mingw32/include"
           ))
(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs cedet-win32-include-dirs)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
;; ok on windows
;(if wttr/os:windowsp
;(eval-after-load "semantic-c"
;'(dolist (d (list "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++"
;                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32"
;                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/backward"
;                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include"
;                  "D:/MinGW/include"
;                  "D:/MinGW/lib/gcc/mingw32/4.8.1/include-fixed"
;                  "D:/MinGW/mingw32/include"
;))
;(semantic-add-system-include d))))
;; I don't why, 
;(if wttr/os:windowsp
;    (message "%s" system-type)
;因为semantic的大部分功能是autoload的，如果不在这儿load semantic-c，那打开一个c文件时会自动load semantic-c，它会把semantic-dependency-system-include-path重设为/usr/include，结果就造成前面自定义的include路径丢失了
;    (require 'semantic-c nil 'noerror) 
;    (semantic-add-system-include "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++" 'c++-mode)
;    (semantic-add-system-include "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/mingw32" 'c++-mode)
;    (semantic-add-system-include "D:/MinGW/lib/gcc/mingw32/4.8.1/include/c++/backward" 'c++-mode)
;    (semantic-add-system-include "D:/MinGW/lib/gcc/mingw32/4.8.1/include" 'c++-mode)
;    (semantic-add-system-include "D:/MinGW/include" 'c++-mode)
;    (semantic-add-system-include "D:/MinGW/lib/gcc/mingw32/4.8.1/include-fixed" 'c++-mode)
;    (semantic-add-system-include "D:/MinGW/mingw32/include" 'c++-mode))

;; for auto-complete
;(defun my-c-mode-cedet-hook ()
;	(add-to-list 'ac-source 'ac-source-gtags)
;	(add-to-list 'ac-source 'ac-source-semantic)
;	(add-to-list 'ac-source 'ac-source-semantic-raw))
;(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
(provide 'semantic-settings)
