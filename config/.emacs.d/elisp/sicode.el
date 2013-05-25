;; YASnippet
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet-0.6.1c/snippets")

;;auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
(ac-config-default)

;;cedet
(global-ede-mode 1)                      ; Enable the Project management system
;; Enable code helpers.
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu
(global-semantic-mru-bookmark-mode 1)

