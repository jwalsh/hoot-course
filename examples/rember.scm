
(define (rember a lat)
  (cond
    ((null? lat) '())
    ((eq? (car lat) a) (cdr lat))
    (else (cons (car lat) (rember a (cdr lat))))))

(display (rember 'mint '(lamb chops and mint jelly)))
(newline)

