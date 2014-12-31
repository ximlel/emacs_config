(require 'wttr-utils)
(require 'cedet)

;; Enabling Semantic (code-parsing, smart completion) feature, Select one of the following:
;;最低要求
(semantic-load-enable-minimum-features)
;;主要是加了一个imenu菜单(不过这个菜单在windows和mac上都显示不出来)
;;(semantic-load-enable-code-helpers)
;;加入了一些用处不大的功能，比如在第一行显示当前的函数等（这个命令已经不建议使用了）
;; (semantic-load-enable-guady-code-helpers)
;;加了在mode line显示当前函数名的功能，也没多大用
 (semantic-load-enable-excessive-code-helpers)
;;用于调试 semantic本身
 (semantic-load-enable-semantic-debugging-helpers)

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
;  (local-set-key [(meta ?/)] 'semantic-ia-complete-symbol-menu))
  (local-set-key [(control tab)] 'semantic-ia-complete-symbol-menu)

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

;; semantic 检索范围
(setq semanticdb-project-roots
      (list
       (expand-file-name "/")))
;;设置semantic cache path
(setq semanticdb-default-save-directory "~/.emacs.d/")

(if wttr/os:windowsp
    (semantic-add-system-include "D:/mingw/lib/gcc/mingw32/4.8.1/include/c++" 'c++-mode)
    (semantic-add-system-include "D:/mingw/lib/gcc/mingw32/4.8.1/include/c++/mingw32" 'c++-mode)
    (semantic-add-system-include "D:/mingw/lib/gcc/mingw32/4.8.1/include/c++/backward" 'c++-mode)
    (semantic-add-system-include "D:/mingw/lib/gcc/mingw32/4.8.1/include" 'c++-mode)
    (semantic-add-system-include "D:/mingw/include" 'c++-mode)
    (semantic-add-system-include "D:/mingw/lib/gcc/mingw32/4.8.1/include-fixed" 'c++-mode)
    (semantic-add-system-include "D:/mingw/mingw32/include" 'c++-mode))

(provide 'semantic-settings)