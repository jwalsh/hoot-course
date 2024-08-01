
(use-modules (srfi srfi-64))

(test-begin "eqlist")
(test-assert "equal lists"
             (eqlist? '(strawberry ice cream) '(strawberry ice cream)))
(test-assert (not (eqlist? '(strawberry ice cream) '(strawberry cream ice))))
(test-end "eqlist")

