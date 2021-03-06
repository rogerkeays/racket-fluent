#lang racket/base

(require (for-syntax racket/base) syntax/parse/define)
(provide (rename-out [parse #%app])
         gt? gte? lt? lte? add subtract multiply divide && ||
         iterate)

(define-syntax-parser parse 

  ;; fluent function composition with >
  [(_ data (~seq (~literal >) proc (~and args (~not (~literal >)) (~not (~literal >>))) ...)) #'(#%app proc data args ...)]
  [(_ data (~seq (~literal >) proc (~and args (~not (~literal >)) (~not (~literal >>))) ...) rest ...) #'(parse (proc data args ...) rest ...)]
  [(_ data (~seq (~literal >>) proc (~and args (~not (~literal >)) (~not (~literal >>))) ...)) #'(#%app proc args ... data)]
  [(_ data (~seq (~literal >>) proc (~and args (~not (~literal >)) (~not (~literal >>))) ...) rest ...) #'(parse (proc args ... data) rest ...)]
  
  ;; fluent function composition with →
  [(_ data (~seq (~literal →) proc (~and args (~not (~literal →)) (~not (~literal →→))) ...)) #'(#%app proc data args ...)]
  [(_ data (~seq (~literal →) proc (~and args (~not (~literal →)) (~not (~literal →→))) ...) rest ...) #'(parse (proc data args ...) rest ...)]
  [(_ data (~seq (~literal →→) proc (~and args (~not (~literal →)) (~not (~literal →→))) ...)) #'(#%app proc args ... data)]
  [(_ data (~seq (~literal →→) proc (~and args (~not (~literal →)) (~not (~literal →→))) ...) rest ...) #'(parse (proc args ... data) rest ...)]

  ;; single expression anonymous functions with a semicolon
  [(_ (~seq (~and params (~not (~literal :))) ...) (~literal :) atom) #'(lambda (params ...) atom)]
  [(_ (~seq (~and params (~not (~literal :))) ...) (~literal :) expr ...) #'(lambda (params ...) (parse expr ...))]

  ;; default parser
  [(_ rest ...) #'(#%app rest ...)])

;; > breaks the greater-than procedure, so provide some alternatives
(define (gt? a b) (> a b))
(define (lt? a b) (< a b))
(define (gte? a b) (>= a b))
(define (lte? a b) (<= a b))

;; these procedures read better as text using fluent function composition
(define (add rest ...) (+ rest ...))
(define (subtract rest ...) (- rest ...))
(define (multiply rest ...) (* rest ...))
(define (divide rest ...) (/ rest ...))

;; parse doesn't work with built-in racket macros and and or, so wrap them in a procedure
(define (&& rest ...) (and rest ...))
(define (|| rest ...) (or rest ...))

;; convenience procedures
(define (iterate list proc) (for-each proc list))

