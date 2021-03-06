#lang racket

;; run with raco test test.rkt
(module+ test
  (require fluent rackunit)
  ("FOO" → string-downcase → check-equal? "foo")
  ("FOO" → (x : string-downcase x) → check-equal? "foo")
  (((x y : + x y) 1 2) → check-equal? 3)
  (((x y : x → + y) 1 2) → check-equal? 3)
  (((x y : x → add y) 1 2) → check-equal? 3)
  ((sort '(3 2 1) (a b : a → lt? b)) → check-equal? '(1 2 3))
  ((sort '(1 2 3) (a b : a → gt? b)) → check-equal? '(3 2 1))
  (((e : #f) 0) → check-equal? #f)
)

