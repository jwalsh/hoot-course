
(define (member* a l)
  (cond
    ((null? l) #f)
    ((atom? (car l))
     (or (eq? (car l) a)
         (member* a (cdr l))))
    (else (or (member* a (car l))
              (member* a (cdr l))))))

(define (atom? x)
  (and (not (pair? x)) (not (null? x))))

(display (member* 'chips '((potato) (chips ((with) (salt))) (and . fish))))
(newline)

