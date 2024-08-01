
(define (multirember a lat)
  (cond
    ((null? lat) '())
    ((eq? (car lat) a) (multirember a (cdr lat)))
    (else (cons (car lat) (multirember a (cdr lat))))))

(display (multirember 'cup '(coffee cup tea cup and hick cup)))
(newline)

