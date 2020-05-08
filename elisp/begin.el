(message "hello world")

; simaple
; list

(defvar elsp_x 'isaavr "commont")
(message "%s" elsp_x)
(set elsp_x 'change_value)


(setq elsp_y 'anothervalue)
(message "%s" elsp_y)

; local param and fun
(defun cspace (r)
"calculate space of"
 (let ((pi 3.1415926) space)
   (setq space (* pi r r))
   (message "r is %.2f, space is %.2f" r space)
  )
 )
(cspace 3)


; lambda
; example (lambda (param) "comment" (fun_body))
(funcall (lambda (name) "say_hi_to_people" (message "hi, %s!" name))  "yu")
(setq sayhi (lambda (name) "say_hi_to_people" (message "hi, %s!" name)))
(funcall sayhi "yu")

;structure control
;(progn A B C ...)
(progn
  (setq foo 3)
  (message "Square of %d is %d" foo (* foo foo))
)


;condition
; (if condition
;     then part
;     else part  // can pass else
; )

(defun who_larger (a b)
  "compare a and b, who is larger"
  (if (> a b)
      (message "%d is large" a)
      (message "%d is large" b)
  )
)
(who_larger 9 5)

;cond
(defun say_one_word (word)
 "comment"
 (let ((first word))
;   (message "%s" first)
   (cond ((string= first "one") (message "%s: 1 1 1" first))
         ((string= first "two") (message "%s: 1 1 1" first))
         ((string= first "three") (message "%s: 1 1 1" first))
         ((string= first "four") (message "%s: 1 1 1" first))
         (t (message "no key: %s" word))
   )
  
 )
)

(say_one_word "two")

;fbinaqi
(defun fib (n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (t (+ (fib (- n 1))
              (fib (- n 2))
           )
        )        
   )
)
(fib 10)

; while
(defun factorial (n)
  (let ((res 1))
    (message "input %d" n)
    (while (> n 1)
      (setq res (* res n)
            n (- n 1)
      )
    )
    res
  )
)

(factorial 10)

; logic compute
; or
(defun hello_world (&optional name)
  (or name (setq name "Emacser"))
  (message "hello, %s" name)
)

(hello_world)
(hello_world "Ye")


;and
(defun square_num_p (n)
  (and (>= n 0)
       (= (/ n (round (sqrt n))) (sqrt n))
  )
)

(square_num_p -1)
(square_num_p 25)
