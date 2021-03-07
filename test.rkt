#lang racket

;; run with raco test test.rkt
(module+ test
  (require fluent rackunit)

  ;; renamed procedures
  (check-equal? (+ 1 1) 2)
  (check-equal? (add 1 1) 2)
  (check-equal? (subtract 1 1) 0)
  (check-equal? (gt? 1 0) #t)
  (check-equal? (gte? 1 1) #t)

  ;; function composition
  ("FOO" > string-downcase > check-equal? "foo")
  ("FOO" → string-downcase → check-equal? "foo")
  ;; ("FOO" > string-downcase → check-equal? "foo") ;; broken: test.rkt:17:27: →: unbound identifier
  ;; ("FOO" → string-downcase > check-equal? "foo") ;; broken: interprets > as a procedure
  ("FOO" > string-ref (1 > subtract 1) > char-downcase > check-equal? #\f)
  ("FOO" → string-ref (1 → subtract 1) → char-downcase → check-equal? #\f)

  ;; lambda shorthand syntax
  (((e : #f) 0) → check-equal? #f)
  (((e : #t) 0) → check-equal? #t)
  (((x y : + x y) 1 2) → check-equal? 3)

  ;; combinations
  ("FOO" > (x : string-downcase x) > check-equal? "foo")
  ("FOO" → (x : string-downcase x) → check-equal? "foo")
  (((x y : x > add y) 1 2) > check-equal? 3)
  (((x y : x → add y) 1 2) → check-equal? 3)
  ((sort '(3 2 1) (a b : a → lt? b)) → check-equal? '(1 2 3))
  ((sort '(1 2 3) (a b : a → gt? b)) → check-equal? '(3 2 1)))

