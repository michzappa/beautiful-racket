#lang br/quicklang

;; read-syntax is used for a "reader" language
;; positional arguments path and port, read from port. 
(define (read-syntax path port)
  ;; get the lines of the program
  (define src-lines (port->lines port))
  ;; make datums from the lines
  (define src-datums (format-datums '~a src-lines))
  ;; turn datums into a single module. ` enables "interpolation" of values,
  ;; so ,@ inserts all the contents of src-datums
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  ;; turn module into a syntax object
  (datum->syntax #f module-datum))
(provide read-syntax)

;; make a macro with a non-conflicting name (non-conflicting with #%module-begin)
(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

(define (handle-args . args)
  (for/fold ([stack-acc empty]) ;; accumulator for fold
            ([arg [in-list args]] ;; iterator for fold
             #:unless (void? arg)) ;; skip blank lines
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result
         (arg (first stack-acc) (second stack-acc)))
         (cons op-result (drop stack-acc 2))])))
(provide handle-args)

(provide + *)