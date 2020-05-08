(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(setq interpreter-mode-alist(cons '("lua" . lua-mode)
interpreter-mode-alist))

;(eval-after-load "lua-mode"
;  '(progn
;     )

(defun si-lua-mode-hook ()
     (setq-default indent-tabs-mode nil)
     (setq tab-width 4))
(add-hook 'lua-mode-hook 'si-lua-mode-hook)
