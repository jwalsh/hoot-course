
(use-modules (srfi srfi-64))

(test-begin "numbered")
(test-assert "valid arithmetic expression"
             (numbered? '(3 + (4 * 5))))
(test-assert (not (numbered? '(2 * sausage))))
(test-end "numbered")

