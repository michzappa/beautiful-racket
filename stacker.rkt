#lang br/quicklang

;; read-syntax is used for a "reader" language
;; positional arguments path and port, read from port. 
(define (read-syntax path port)
  ;; get the lines of the program
  (define src-lines (port->lines port))
  ;; make datums from the lines
  (define src-datums (format-datums '(handle ~a) src-lines))
  ;; turn datums into a single module. ` enables "interpolation" of values,
  ;; so ,@ inserts all the contents of src-datums
  (define module-datum `(module stacker-mod "stacker.rkt"
                          ,@src-datums))
  ;; turn module into a syntax object
  (datum->syntax #f module-datum))
(provide read-syntax)

;; make a macro with a non-conflicting name (non-conflicting with #%module-begin)
(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin
    HANDLE-EXPR ...
     (display (first stack))))
(provide (rename-out [stacker-module-begin #%module-begin]))

(define stack empty)

(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  (set! stack (cons arg stack)))

;; handle an operation on the stack, operating whether it is a number
;; or an operation
(define (handle [arg #f])
  (cond
   [(number? arg) (push-stack! arg)]
   [(or (equal? + arg) (equal? * arg))
    (define op-result (arg (pop-stack!) (pop-stack!)))
    (push-stack! op-result)]))
(provide handle)

(provide + *)