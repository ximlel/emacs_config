;;
;; * tab
(defun user-tab ()
  (interactive)
  (let ((input (eshell-get-old-input)))
    (if (string-equal input "")
        (insert-string "cd ")
      (progn
        (cond
         ((string-equal input "cd  ")
          (delete-backward-char 1)
          (insert-string "-0"))
         ((string-match "^cd\\ -[0-9]+$" input)
          (let ((len (length input)))
            (delete-backward-char (- len 4))
            (insert-string (1+ (read(substring input 4 len))))))
         (t
          (pcomplete))
         )))))

;; * ret
(defun user-ret ()
  (interactive)
  (let ((input (eshell-get-old-input)))
    (if (string-equal input "")
        (progn
          (insert-string "ls")
          (eshell-send-input))
      (progn
        (cond
         ((string-match "^cd\\ \\.\\{2,\\}$" input)
          (let ((len (- (length input) 5))
                (dots (lambda (n d)(if (<= n 0) nil (concat (funcall dots (1- n) d) d)))))
            (eshell-bol)(kill-line)
            (insert-string (concat "cd .." (funcall dots len "/..")))
            (eshell-send-input)))
         ((string-match "^\\.\\{2,\\}$" input)
          (let ((len (- (length input) 2))(p ".."))
            (while (> len 0)
              (setq len (1- len))(setq p (concat p "/..")))
            (eshell-bol)(kill-line)
            (insert-string p)
            (eshell-send-input)))
         (t
          (eshell-send-input))))
      )))

;; * spc
(defun user-spc ()
  (interactive)
  (let ((input (eshell-get-old-input)))
    (if (string-equal input "")
        (insert-string "!-1")
      (progn
        (cond
         ((string-match "^!-[0-9]+$" input)
          (let ((len (length input)))
            (delete-backward-char (- len 2))
            (insert-string (1+ (read(substring input 2 len))))))
         (t
          (self-insert-command 1))
         )))))

;; * del
;; (defun user-del ()
;;   (interactive)
;;   (let ((input (eshell-get-old-input)))
;;     (if (string-equal input "")
;;         (progn
;;           (insert-string "..")
;;           (eshell-send-input))
;;         (delete-backward-char 1)
;;         )))

(provide 'eshell-user-key)
