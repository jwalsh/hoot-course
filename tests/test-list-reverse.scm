
(use-modules (srfi srfi-64))

(test-begin "list-reverse")

(test-equal "reverse empty list" '() (my-reverse '()))
(test-equal "reverse list" '(5 4 3 2 1) (my-reverse '(1 2 3 4 5)))

(test-end "list-reverse")

