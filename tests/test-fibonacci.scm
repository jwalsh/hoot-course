
(use-modules (srfi srfi-64))

(test-begin "fibonacci")

(test-equal "fib of 0" 0 (fib 0))
(test-equal "fib of 1" 1 (fib 1))
(test-equal "fib of 10" 55 (fib 10))

(test-end "fibonacci")

