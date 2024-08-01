
(use-modules (srfi srfi-64))

(test-begin "leftmost")
(test-equal "leftmost of nested list" 'potato
            (leftmost '((potato) (chips ((with) (salt))) (and . fish))))
(test-equal "leftmost of simple list" 'a
            (leftmost '(a b c)))
(test-end "leftmost")

