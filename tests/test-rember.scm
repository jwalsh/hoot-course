
(use-modules (srfi srfi-64))

(test-begin "rember")
(test-equal "remove 'mint" '(lamb chops and jelly)
            (rember 'mint '(lamb chops and mint jelly)))
(test-equal "remove 'toast" '(bacon lettuce and tomato)
            (rember 'toast '(bacon lettuce and tomato)))
(test-end "rember")

