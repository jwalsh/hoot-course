
(use-modules (srfi srfi-64))

(test-begin "value")
(test-equal "evaluate arithmetic expression" 13
            (value '(1 + (3 * 4))))
(test-equal "evaluate power expression" 8
            (value '(2 ^ 3)))
(test-end "value")

