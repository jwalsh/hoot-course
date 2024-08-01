
(use-modules (srfi srfi-64))

(test-begin "insertg-r")
(test-equal "insert 'topping after 'fudge"
            '(ice cream with fudge topping for dessert)
            (insertg-r 'topping 'fudge '(ice cream with fudge for dessert)))
(test-equal "insert 'jalapeno after 'and"
            '(tacos tamales and jalapeno salsa)
            (insertg-r 'jalapeno 'and '(tacos tamales and salsa)))
(test-end "insertg-r")

