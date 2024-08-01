
(use-modules (srfi srfi-64))

(test-begin "multirember")
(test-equal "remove all 'cup" '(coffee tea and hick)
            (multirember 'cup '(coffee cup tea cup and hick cup)))
(test-equal "remove all 'bacon" '(lettuce and tomato)
            (multirember 'bacon '(bacon lettuce and tomato)))
(test-end "multirember")

