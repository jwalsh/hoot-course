
(define (numbered? aexp)
  (cond
    ((atom? aexp) (number? aexp))
    ((eq? (cadr aexp) '+)
     (and (numbered? (car aexp)) (numbered? (caddr aexp))))
    ((eq? (cadr aexp) '*)
     (and (numbered? (car aexp)) (numbered? (caddr aexp))))
    ((eq? (cadr aexp) '^)
     (and (numbered? (car aexp)) (numbered? (caddr aexp))))
    (else #f)))

(define (atom? x)
  (and (not (pair? x)) (not (null? x))))

(display (numbered? '(3 + (4 * 5))))
(newline)

