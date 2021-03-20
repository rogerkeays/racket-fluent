#lang racket

;; run with raco test
(module+ test
  (require "short.rkt" rackunit)

  ;; renamed procedures
  (check-equal? (+ 1 1) 2)
  (check-equal? (add 1 1) 2)
  (check-equal? (subtract 1 1) 0)
  (check-equal? (gt? 1 0) #t)
  (check-equal? (gte? 1 1) #t)

  ;; lambda shorthand
  (check-equal? ((e : #f) 0) #f)
  (check-equal? ((e : #t) 0) #t)
  (check-equal? ((x y : + x y) 1 2) 3)

  ;; function composition
  ("FOO" > string-downcase > check-equal? "foo")
  ("FOO" > string-ref (1 > subtract 1) > char-downcase > check-equal? #\f)
  ('(1 2 3) >> map (lambda (x) (+ x 1)) > check-equal? '(2 3 4))

  ;; function composition and lambda shorthand combined
  ("FOO" > (x : string-downcase x) > check-equal? "foo")
  (((x y : x > add y) 1 2) > check-equal? 3)
  ((sort '(3 2 1) (a b : a > lt? b)) > check-equal? '(1 2 3))
  ((sort '(1 2 3) (a b : a > gt? b)) > check-equal? '(3 2 1)))

