
(define (eqlist? l1 l2)
  (cond
    ((and (null? l1) (null? l2)) #t)
    ((or (null? l1) (null? l2)) #f)
    ((and (atom? (car l1)) (atom? (car l2)))
     (and (eq? (car l1) (car l2))
          (eqlist? (cdr l1) (cdr l2))))
    ((or (atom? (car l1)) (atom? (car l2))) #f)
    (else
     (and (eqlist? (car l1) (car l2))
          (eqlist? (cdr l1) (cdr l2))))))

(define (atom? x)
  (and (not (pair? x)) (not (null? x))))

(display (eqlist? '(strawberry ice cream) '(strawberry ice cream)))
(newline)

