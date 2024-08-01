
(define (occur a lat)
  (cond
    ((null? lat) 0)
    ((eq? (car lat) a) (add1 (occur a (cdr lat))))
    (else (occur a (cdr lat)))))

(display (occur 'banana '(banana apple banana orange banana kiwi)))
(newline)

