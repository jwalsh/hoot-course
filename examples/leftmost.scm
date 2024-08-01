
(define (leftmost l)
  (cond
    ((atom? l) l)
    ((null? l) '())
    (else (leftmost (car l)))))

(define (atom? x)
  (and (not (pair? x)) (not (null? x))))

(display (leftmost '((potato) (chips ((with) (salt))) (and . fish))))
(newline)

