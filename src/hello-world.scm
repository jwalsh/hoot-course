;;; hello-world.scm -- Simple "Hello, World!" example using Guile Hoot
;;;
;;; Author: Jason Walsh <j@wal.sh>
;;; Date: 2024-08-01
;;; Description: This script demonstrates basic DOM manipulation using
;;;              Guile Hoot's foreign function interface (FFI) to create
;;;              a simple "Hello, World!" web page.
;;;
;;; Copyright (C) 2024 Jason Walsh
;;; Licensed under the GNU General Public License version 3 or later.

;;; Code:

(use-modules (wasm dom)
             (wasm js)
             (wasm ffi))

;;; FFI Declarations:

(define-foreign document-body
  "document" "body"
  ;; Parameters: none
  ;; Result: an external reference which may be null
  -> (ref null extern))

(define-foreign make-text-node
  "document" "createTextNode"
  ;; Parameters: a string
  ;; Result: an external reference which may be null
  (ref string) -> (ref null extern))

(define-foreign append-child!
  "element" "appendChild"
  ;; Parameters: two external references which may be null
  ;; Result: an external reference which may be null
  (ref null extern) (ref null extern) -> (ref null extern))

;;; Main Procedure:

(define (main)
  (append-child! (document-body) (make-text-node "Hello, world!")))

;; Run the main procedure
(main)

;;; hello-world.scm ends here
