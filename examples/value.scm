
(define (value nexp)
  (cond
    ((number? nexp) nexp)
    ((eq? (cadr nexp) '+)
     (+ (value (car nexp)) (value (caddr nexp))))
    ((eq? (cadr nexp) '*)
     (* (value (car nexp)) (value (caddr nexp))))
    ((eq? (cadr nexp) '^)
     (expt (value (car nexp)) (value (caddr nexp))))))

(display (value '(1 + (3 * 4))))
(newline)

