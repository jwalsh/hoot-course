#!/bin/bash

# Function to create a Scheme file and its associated test file
create_scheme_file() {
    local filename=$1
    local content=$2
    local test_content=$3

    echo "$content" > "examples/$filename.scm"
    echo "$test_content" > "tests/test-$filename.scm"
    echo "Created $filename.scm and test-$filename.scm"
}

# Ensure directories exist
mkdir -p examples tests

# 1. Factorial (from SICP)
create_scheme_file "factorial" "
(define (factorial n)
  (if (zero? n)
      1
      (* n (factorial (- n 1)))))

(display (factorial 5))
(newline)
" "
(use-modules (srfi srfi-64))

(test-begin \"factorial\")
(test-equal \"factorial of 0\" 1 (factorial 0))
(test-equal \"factorial of 5\" 120 (factorial 5))
(test-end \"factorial\")
"

# 2. Rember (from The Little Schemer)
create_scheme_file "rember" "
(define (rember a lat)
  (cond
    ((null? lat) '())
    ((eq? (car lat) a) (cdr lat))
    (else (cons (car lat) (rember a (cdr lat))))))

(display (rember 'mint '(lamb chops and mint jelly)))
(newline)
" "
(use-modules (srfi srfi-64))

(test-begin \"rember\")
(test-equal \"remove 'mint\" '(lamb chops and jelly)
            (rember 'mint '(lamb chops and mint jelly)))
(test-equal \"remove 'toast\" '(bacon lettuce and tomato)
            (rember 'toast '(bacon lettuce and tomato)))
(test-end \"rember\")
"

# 3. Insertg R (from The Little Schemer)
create_scheme_file "insertg-r" "
(define (insertg-r new old lat)
  (cond
    ((null? lat) '())
    ((eq? (car lat) old)
     (cons old (cons new (cdr lat))))
    (else (cons (car lat)
                (insertg-r new old (cdr lat))))))

(display (insertg-r 'topping 'fudge '(ice cream with fudge for dessert)))
(newline)
" "
(use-modules (srfi srfi-64))

(test-begin \"insertg-r\")
(test-equal \"insert 'topping after 'fudge\"
            '(ice cream with fudge topping for dessert)
            (insertg-r 'topping 'fudge '(ice cream with fudge for dessert)))
(test-equal \"insert 'jalapeno after 'and\"
            '(tacos tamales and jalapeno salsa)
            (insertg-r 'jalapeno 'and '(tacos tamales and salsa)))
(test-end \"insertg-r\")
"

# 4. Multirember (from The Little Schemer)
create_scheme_file "multirember" "
(define (multirember a lat)
  (cond
    ((null? lat) '())
    ((eq? (car lat) a) (multirember a (cdr lat)))
    (else (cons (car lat) (multirember a (cdr lat))))))

(display (multirember 'cup '(coffee cup tea cup and hick cup)))
(newline)
" "
(use-modules (srfi srfi-64))

(test-begin \"multirember\")
(test-equal \"remove all 'cup\" '(coffee tea and hick)
            (multirember 'cup '(coffee cup tea cup and hick cup)))
(test-equal \"remove all 'bacon\" '(lettuce and tomato)
            (multirember 'bacon '(bacon lettuce and tomato)))
(test-end \"multirember\")
"

# 5. Occur (from The Little Schemer)
create_scheme_file "occur" "
(define (occur a lat)
  (cond
    ((null? lat) 0)
    ((eq? (car lat) a) (add1 (occur a (cdr lat))))
    (else (occur a (cdr lat)))))

(display (occur 'banana '(banana apple banana orange banana kiwi)))
(newline)
" "
(use-modules (srfi srfi-64))

(test-begin \"occur\")
(test-equal \"count occurrences of 'banana\" 3
            (occur 'banana '(banana apple banana orange banana kiwi)))
(test-equal \"count occurrences of 'apple\" 1
            (occur 'apple '(banana apple banana orange banana kiwi)))
(test-end \"occur\")
"

# 6. Member* (from The Little Schemer)
create_scheme_file "member-star" "
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
" "
(use-modules (srfi srfi-64))

(test-begin \"member-star\")
(test-assert \"find 'chips in nested list\"
             (member* 'chips '((potato) (chips ((with) (salt))) (and . fish))))
(test-assert (not (member* 'bacon '((potato) (chips ((with) (salt))) (and . fish)))))
(test-end \"member-star\")
"

# 7. Leftmost (from The Little Schemer)
create_scheme_file "leftmost" "
(define (leftmost l)
  (cond
    ((atom? l) l)
    ((null? l) '())
    (else (leftmost (car l)))))

(define (atom? x)
  (and (not (pair? x)) (not (null? x))))

(display (leftmost '((potato) (chips ((with) (salt))) (and . fish))))
(newline)
" "
(use-modules (srfi srfi-64))

(test-begin \"leftmost\")
(test-equal \"leftmost of nested list\" 'potato
            (leftmost '((potato) (chips ((with) (salt))) (and . fish))))
(test-equal \"leftmost of simple list\" 'a
            (leftmost '(a b c)))
(test-end \"leftmost\")
"

# 8. Eqlist? (from The Little Schemer)
create_scheme_file "eqlist" "
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
" "
(use-modules (srfi srfi-64))

(test-begin \"eqlist\")
(test-assert \"equal lists\"
             (eqlist? '(strawberry ice cream) '(strawberry ice cream)))
(test-assert (not (eqlist? '(strawberry ice cream) '(strawberry cream ice))))
(test-end \"eqlist\")
"

# 9. Numbered? (from The Little Schemer)
create_scheme_file "numbered" "
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
" "
(use-modules (srfi srfi-64))

(test-begin \"numbered\")
(test-assert \"valid arithmetic expression\"
             (numbered? '(3 + (4 * 5))))
(test-assert (not (numbered? '(2 * sausage))))
(test-end \"numbered\")
"

# 10. Value (from The Little Schemer)
create_scheme_file "value" "
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
" "
(use-modules (srfi srfi-64))

(test-begin \"value\")
(test-equal \"evaluate arithmetic expression\" 13
            (value '(1 + (3 * 4))))
(test-equal \"evaluate power expression\" 8
            (value '(2 ^ 3)))
(test-end \"value\")
"

echo "All example files and tests have been created!"
