<<<<<<< HEAD

(require 'eassist nil 'noerror)
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))
(defun si-c-mode-common-hook()
  (setq-default indent-tabs-mode nil)
  (setq tab-width 4)
  ;; 输入";{}"等字符是自动开始一行并缩进， C-c C-a开关
  ;(c-toggle-auto-hungry-state 1)
  ;; key setting
  ;;C-c M-H	highlight-symbol-at-point    ;; 高亮这个关键字
  ;;C-c M-R	highlight-symbol-remove-all
  ;;C-c M-N	highlight-symbol-next
  ;;C-c M-P	highlight-symbol-prev
  (define-key c-mode-base-map [M-S-f12] 'semantic-analyze-proto-impl-toggle) ;; 在函数声明和定义中跳转
  (define-key c-mode-base-map [M-f12] 'eassist-switch-h-cpp)
  ;eassist-list-methods	                                                     ;; 列出当前buffer中的函数
  ;(define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)  
  ;(define-key c-mode-base-map [(return)] 'newline-and-indent)  
  ;(define-key c-mode-base-map [(f7)] 'compile)  
  ;;(define-key c-mode-base-map [(f8)] 'ff-get-other-file)  
  ;(define-key c-mode-base-map [(meta \`)] 'c-indent-command)
  ;(define-key c-mode-base-map [(tab)] 'hippie-expand)  
  ;(define-key c-mode-base-map [(tab)] 'my-indent-or-complete)  
  ;(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
;;预处理设置
  ;(setq c-macro-shrink-window-flag t)  
  ;(setq c-macro-preprocessor "cpp")  
  ;(setq c-macro-cppflags " ")  
  ;(setq c-macro-prompt-flag t)  
  ;(setq hs-minor-mode t)  
  ;(setq abbrev-mode t)  
  (setq tab-width 4 indent-tabs-mode nil)  
  ;(setq default-fill-column 80)  
  )

(add-hook 'c-mode-common-hook 'si-c-mode-common-hook)

(defun si-c++-mode-hook()
  ;(c-set-style "stroustrup") ;; 两空格缩进
  )
(add-hook 'c++-mode-hook 'si-c++-mode-hook)
=======

(require 'eassist nil 'noerror)
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))
(defun si-c-mode-common-hook()
  ;; 输入";{}"等字符是自动开始一行并缩进， C-c C-a开关
  ;(c-toggle-auto-hungry-state 1)
  ;; key setting
  ;;C-c M-H	highlight-symbol-at-point    ;; 高亮这个关键字
  ;;C-c M-R	highlight-symbol-remove-all
  ;;C-c M-N	highlight-symbol-next
  ;;C-c M-P	highlight-symbol-prev
  (define-key c-mode-base-map [M-S-f12] 'semantic-analyze-proto-impl-toggle) ;; 在函数声明和定义中跳转
  (define-key c-mode-base-map [M-f12] 'eassist-switch-h-cpp)
  ;eassist-list-methods	                                                     ;; 列出当前buffer中的函数
  ;(define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)  
  ;(define-key c-mode-base-map [(return)] 'newline-and-indent)  
  ;(define-key c-mode-base-map [(f7)] 'compile)  
  ;;(define-key c-mode-base-map [(f8)] 'ff-get-other-file)  
  ;(define-key c-mode-base-map [(meta \`)] 'c-indent-command)
  ;(define-key c-mode-base-map [(tab)] 'hippie-expand)  
  ;(define-key c-mode-base-map [(tab)] 'my-indent-or-complete)  
  ;(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
;;预处理设置
  ;(setq c-macro-shrink-window-flag t)  
  ;(setq c-macro-preprocessor "cpp")  
  ;(setq c-macro-cppflags " ")  
  ;(setq c-macro-prompt-flag t)  
  ;(setq hs-minor-mode t)  
  ;(setq abbrev-mode t)  
  (setq tab-width 4 indent-tabs-mode nil)  
  ;(setq default-fill-column 80)  
  )

(add-hook 'c-mode-common-hook 'si-c-mode-common-hook)

(defun si-c++-mode-hook()
  ;(c-set-style "stroustrup") ;; 两空格缩进
  )
(add-hook 'c++-mode-hook 'si-c++-mode-hook)
>>>>>>> c994c3026c1ce5a218431469bdb3789ead770b32
