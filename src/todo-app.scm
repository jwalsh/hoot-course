;;; todo-app.scm -- A comprehensive todo application using Guile Hoot

;; Import necessary modules
(use-modules (wasm dom)
             (wasm js)
             (wasm ffi)
             (srfi srfi-9))  ; for define-record-type

;; FFI declarations
(define-foreign document-body
  "document" "body"
  -> (ref null extern))

(define-foreign get-element-by-id
  "document" "getElementById"
  (ref string) -> (ref null extern))

(define-foreign make-element
  "document" "createElement"
  (ref string) -> (ref null extern))

(define-foreign make-text-node
  "document" "createTextNode"
  (ref string) -> (ref null extern))

(define-foreign append-child!
  "element" "appendChild"
  (ref null extern) (ref null extern) -> (ref null extern))

(define-foreign set-attribute!
  "element" "setAttribute"
  (ref null extern) (ref string) (ref string) -> none)

(define-foreign add-event-listener!
  "element" "addEventListener"
  (ref null extern) (ref string) (ref null extern) -> none)

(define-foreign remove-event-listener!
  "element" "removeEventListener"
  (ref null extern) (ref string) (ref null extern) -> none)

(define-foreign remove!
  "element" "remove"
  (ref null extern) -> none)

(define-foreign replace-with!
  "element" "replaceWith"
  (ref null extern) (ref null extern) -> none)

(define-foreign remove-attribute!
  "element" "removeAttribute"
  (ref null extern) (ref string) -> none)

(define-foreign element-value
  "element" "value"
  (ref null extern) -> (ref string))

(define-foreign set-element-value!
  "element" "setValue"
  (ref null extern) (ref string) -> none)

(define-foreign element-checked?
  "element" "checked"
  (ref null extern) -> bool)

(define-foreign set-element-checked!
  "element" "setChecked"
  (ref null extern) bool -> none)

(define-foreign event-target
  "event" "target"
  (ref null extern) -> (ref null extern))

(define-foreign prevent-default
  "event" "preventDefault"
  (ref null extern) -> none)

;; Define the task record type
(define-record-type <task>
  (make-task id name done? due-date)
  task?
  (id task-id)
  (name task-name set-task-name!)
  (done? task-done? set-task-done!)
  (due-date task-due-date set-task-due-date!))

;; Global state for tasks
(define *tasks* '())
(define *next-id* 0)

;; Task management functions
(define (add-task! name)
  (let ((task (make-task *next-id* name #f #f)))
    (set! *tasks* (cons task *tasks*))
    (set! *next-id* (+ *next-id* 1))
    task))

(define (remove-task! id)
  (set! *tasks* (filter (lambda (task) (not (= (task-id task) id))) *tasks*)))

(define (update-task! id update-fn)
  (set! *tasks*
    (map (lambda (task)
           (if (= (task-id task) id)
               (update-fn task)
               task))
         *tasks*)))

;; UI Components
(define (task-item task)
  `(li (@ (class "task-item"))
       (input (@ (type "checkbox")
                 (checked ,(task-done? task))
                 (change ,(lambda (event)
                            (let ((checked? (element-checked? (event-target event))))
                              (update-task! (task-id task)
                                            (lambda (t) (set-task-done! t checked?) t))
                              (render))))))
       (span (@ (class ,(if (task-done? task) "task-name done" "task-name")))
             ,(task-name task))
       (input (@ (type "date")
                 (value ,(or (task-due-date task) ""))
                 (change ,(lambda (event)
                            (let ((new-date (element-value (event-target event))))
                              (update-task! (task-id task)
                                            (lambda (t) (set-task-due-date! t new-date) t))
                              (render))))))
       (button (@ (class "delete-btn")
                  (click ,(lambda (event)
                            (remove-task! (task-id task))
                            (render))))
               "Delete")))

(define (task-list)
  `(ul (@ (id "task-list"))
       ,@(map task-item (reverse (filter-tasks *tasks*)))))

(define (add-task-form)
  `(form (@ (id "add-task-form")
            (submit ,(lambda (event)
                       (prevent-default event)
                       (let ((input (get-element-by-id "new-task-input")))
                         (let ((task-name (element-value input)))
                           (when (not (string-null? task-name))
                             (add-task! task-name)
                             (set-element-value! input "")
                             (render)))))))
         (input (@ (id "new-task-input")
                   (type "text")
                   (placeholder "Enter a new task")))
         (button (@ (type "submit")) "Add Task")))

(define (filter-controls)
  `(div (@ (id "filter-controls"))
        (button (@ (click ,(lambda (event) (set! *filter* 'all) (render))))
                "All")
        (button (@ (click ,(lambda (event) (set! *filter* 'active) (render))))
                "Active")
        (button (@ (click ,(lambda (event) (set! *filter* 'completed) (render))))
                "Completed")))

;; Main template
(define (template)
  `(div (@ (id "todo-app"))
        (h1 "Todo List")
        ,(add-task-form)
        ,(filter-controls)
        ,(task-list)))

;; Filtering logic
(define *filter* 'all)

(define (filter-tasks tasks)
  (filter (lambda (task)
            (case *filter*
              ((all) #t)
              ((active) (not (task-done? task)))
              ((completed) (task-done? task))
              (else #t)))
          tasks))

;; Rendering
(define *current-vdom* #f)

(define (render)
  (let ((new-vdom (template)))
    (virtual-dom-render (document-body) *current-vdom* new-vdom)
    (set! *current-vdom* new-vdom)))

;; Initialize the app
(define (init-app)
  (add-task! "Learn Guile Hoot")
  (add-task! "Build a todo app")
  (add-task! "Conquer the world")
  (render))

;; Call init-app when the page loads
(add-event-listener! (document-body) "load" init-app)

;; Note: The virtual-dom-render function is not defined here.
;; It should be implemented as described in the Hoot documentation.
