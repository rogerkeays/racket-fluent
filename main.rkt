#lang racket/base

(require (for-syntax racket/base) syntax/parse/define)
(provide (rename-out [parse #%app] [> gt?] [>= gte?] [< lt?] [<= lte?] [+ add] [- subtract] [* multiply] [/ divide])
         : ~> ~~> && || iterate)

;; defining the syntax operators allows them to be renamed using (rename-in)
(define-syntax (: stx) (raise-syntax-error #f "out of context" stx))
(define-syntax (~> stx) (raise-syntax-error #f "out of context" stx))
(define-syntax (~~> stx) (raise-syntax-error #f "out of context" stx))

;; match our parse cases and default to racket/base #%app
(define-syntax-parser parse #:literals (: ~> ~~>)

  ;; infix lambda operator
  [(_ (~seq (~and params (~not :)) ...) : atom) #'(lambda (params ...) atom)]
  [(_ (~seq (~and params (~not :)) ...) : expr ...) #'(lambda (params ...) (parse expr ...))]

  ;; function composition operators
  [(_ data (~seq ~> proc (~and args (~not ~>) (~not ~~>)) ...)) #'(#%app proc data args ...)]
  [(_ data (~seq ~> proc (~and args (~not ~>) (~not ~~>)) ...) rest ...) #'(parse (proc data args ...) rest ...)]
  [(_ data (~seq ~~> proc (~and args (~not ~>) (~not ~~>)) ...)) #'(#%app proc args ... data)]
  [(_ data (~seq ~~> proc (~and args (~not ~>) (~not ~~>)) ...) rest ...) #'(parse (proc args ... data) rest ...)]

  ;; default parser
  [(_ rest ...) #'(#%app rest ...)])

;; function composition doesn't work with built-in racket macros and and or, so wrap them in a procedure
(define (&& rest ...) (and rest ...))
(define (|| rest ...) (or rest ...))

;; convenience procedures
(define (iterate list proc) (for-each proc list))

