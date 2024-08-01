
(use-modules (srfi srfi-64))

(test-begin "occur")
(test-equal "count occurrences of 'banana" 3
            (occur 'banana '(banana apple banana orange banana kiwi)))
(test-equal "count occurrences of 'apple" 1
            (occur 'apple '(banana apple banana orange banana kiwi)))
(test-end "occur")

