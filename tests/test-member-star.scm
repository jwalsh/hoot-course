
(use-modules (srfi srfi-64))

(test-begin "member-star")
(test-assert "find 'chips in nested list"
             (member* 'chips '((potato) (chips ((with) (salt))) (and . fish))))
(test-assert (not (member* 'bacon '((potato) (chips ((with) (salt))) (and . fish)))))
(test-end "member-star")

