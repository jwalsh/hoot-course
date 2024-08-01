
(use-modules (srfi srfi-64))

(test-begin "factorial")
(test-equal "factorial of 0" 1 (factorial 0))
(test-equal "factorial of 5" 120 (factorial 5))
(test-end "factorial")

