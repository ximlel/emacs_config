;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-05-21 18:27:09 Friday by ahei>

(defun font-lock-face-settings ()
  "Face settings for `font-lock'."
  ;; 语法着色
  (if use-black-background
      (progn
;        (set-face-foreground 'font-lock-comment-face "red")
;        (set-face-foreground 'font-lock-string-face "magenta"))
         (custom-set-faces '(font-lock-comment-face ((t :foreground "#465457" :slant italic))))           
         (custom-set-faces '(font-lock-string-face ((t :foreground "#E6DB74")))))          

    (set-face-foreground 'font-lock-comment-face "darkgreen")
    (set-face-foreground 'font-lock-string-face "blue"))
  (custom-set-faces '(font-lock-function-name-face
;                      ((((type tty)) :bold t :background "yellow" :foreground "blue")
;                       (t :background "#45D463DD4FF8" :foreground "yellow"))))
                        ((t :foreground "#F92672" :slant italic))))
  (custom-set-faces '(font-lock-constant-face
;                      ((((type tty)) :bold t :background "white" :foreground "blue")
;                       (t :background "darkslateblue" :foreground "chartreuse"))))
                        ((t :foreground "#AE81FF"))))
;  (set-face-foreground 'font-lock-variable-name-face "#C892FFFF9957")
  (set-face-foreground 'font-lock-variable-name-face "#F92672")
;  (set-face-foreground 'font-lock-keyword-face "cyan")
  (set-face-foreground 'font-lock-keyword-face "#66D9EF")
  (custom-set-faces '(font-lock-comment-delimiter-face
;                      ((((type tty)) :bold t :foreground "red")
;                       (t :foreground "chocolate1"))))
                        ((t :foreground "#465457" :slant italic))))
;  (custom-set-faces '(font-lock-warning-face ((t (:foreground "#FFFFFF" :background "#333333")))))
  (custom-set-faces '(font-lock-warning-face ((t (:background "red" :foreground "white")))))
  (custom-set-faces '(font-lock-doc-face
;                      ((((type tty)) :foreground "green")
;                       (t (:foreground "maroon1")))))
                        ((t :foreground "#E6DB74" :slant italic))))
  (custom-set-faces '(font-lock-type-face
;                      ((((type tty)) :bold t :foreground "green")
;                       (t (:foreground "green")))))
;                        ((t :foreground "#66D9EF"))))
                        ((t :foreground "MediumSpringGreen"))))
  (custom-set-faces '(font-lock-regexp-grouping-backslash
;                      ((((type tty)) :foreground "red")
;                       (t (:foreground "red")))))
                        ((t :weight bold))))
  (custom-set-faces '(font-lock-regexp-grouping-construct
;                      ((((type tty)) :foreground "yellow")
;                       (t (:foreground "yellow"))))))
                        ((((type tty)) :foreground "yellow")
                       (t (:weight bold))))))
;; add by simon
  (custom-set-faces '(font-lock-builtin-face
                      ((t :foreground "#A6E22E"))))
  (custom-set-faces '(font-lock-negation-char-face
                      ((t :weight bold))))
  (custom-set-faces '(font-lock-preprocessor-face
                      ((t :foreground "#A6E22E"))))

(eval-after-load "font-lock"
  `(font-lock-face-settings))

(provide 'font-lock-face-settings)
