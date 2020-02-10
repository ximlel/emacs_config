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
(defun si-python-mode-hook ()
     (setq-default indent-tabs-mode nil)
     (setq tab-width 4))
(add-hook 'python-mode-hook 'si-python-mode-hook)
(setq gud-pdb-marker-regexp "^> \\([-axx-zA-Z0-9_/.:\\]*\\|<string>\\)(\\([0-9]+\\))\\([a-zA-Z0-9_]*\\|\\?\\|<module>\\)()\\(->[^\n\r]*\\)?[\n\r]")