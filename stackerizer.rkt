#lang br/quicklang
(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (for-each displayln (reverse (flatten EXPR)))))
(provide (rename-out [stackerizer-mb #%module-begin]))

;; given an operation, define a macro for handling its cases
;; (... ...) is a special form so the ellipses are used in the
;; generate macros, not define-op itself
;; 'OP ...' means that the (begin ___ ...) will do the action for each
;; argument in 'OP ...'
(define-macro (define-ops OP ...)
  #'(begin
      (define-macro-cases OP
        [(OP FIRST) #'FIRST]
        [(OP FIRST NEXT (... ...))
         #'(list 'OP FIRST (OP NEXT (... ...)))])
      ...))

(define-ops + *)