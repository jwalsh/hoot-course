
(define (insertg-r new old lat)
  (cond
    ((null? lat) '())
    ((eq? (car lat) old)
     (cons old (cons new (cdr lat))))
    (else (cons (car lat)
                (insertg-r new old (cdr lat))))))

(display (insertg-r 'topping 'fudge '(ice cream with fudge for dessert)))
(newline)

