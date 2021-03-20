#lang racket/base

(require "main.rkt")
(provide (except-out (all-from-out "main.rkt") ~> ~~>)
         (rename-out (~> >) (~~> >>)))

