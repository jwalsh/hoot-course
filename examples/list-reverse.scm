
(define (my-reverse lst)
  (if (null? lst)
      '()
      (append (my-reverse (cdr lst)) (list (car lst)))))

(display (my-reverse '(1 2 3 4 5)))
(newline)

