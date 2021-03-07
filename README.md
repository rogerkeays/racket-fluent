
# fluent

UNIX style pipes and lambda shorthand syntax to make your Racket code more readable.

## ? Unpopular So LISP Is Why

Let's be honest. LISP missed a huge opportunity to change the world by telling developers they have to think backwards. Meanwhile, UNIX became successful largely because it allows you to compose programs sequentially using pipes. Compare the difference (the LISP example is actually racket):

    UNIX: cat data.txt | grep "active" | cut -f 4 | uniq | sort
    LISP: (sort (remove-duplicates (map (λ (line) (list-ref (string-split line) 4)) ((filter (λ (line) (string-contains? line "active")) (file->lines "data.txt"))))))

Using *fluent*, the same racket code can be written according to the UNIX philosophy:

    ("data.txt" > file->lines >> filter (line : line > string-contains? "active") >> map (line : line > string-split > list-ref 4) > remove-duplicates > sort)

You can use unicode → instead of > if you prefer. It is more distinctive and a bit easier on the eyes:

    ("data.txt" → file->lines →→ filter (line : line → string-contains? "active") →→ map (line : line → string-split → list-ref 4) → remove-duplicates → sort)

## Function Composition

Using the function composition operator (> or →), *fluent* inserts the left hand side as the first parameter to the procedure on the right hand side. Use >> (or →→) to add the left hand side as the last parameter to the procedure.

    (data > procedure params)     becomes    (procedure data params)
    (data >> procedure params)    becomes    (procedure params data)

This operation can be chained or nested as demonstrated in the examples.

## Lambda Shorthand

The : operator allows you to easily write a lambda function with one expression. Parameters go on the left, the expression on the right, no parentheses required. For example:

    > ((x : + x 1) 1)
    2
    > ((x y : + x y) 1 2)
    3
    > (map (x : string-upcase x) '("a" "b" "c"))
    '("A" "B" "C")

## Math Procedures

Since this library uses > for function composition, the built in greater-than procedure is renamed to `gt?`. Note, this could break existing code if you are already using the > procedure. Other math procedures are also renamed for consistency, and because the text versions read more naturally when using function composition.

    > gt?
    < lt?
    >= gte?
    <= lte?
    + add
    - subtract
    * multiply
    / divide

Check main.rkt for changes to this list.

## Convenience Procedures

*fluent* works best when the data (input) parameter comes first. Most racket functions do this out of the box, but many functions which take a procedure as a parameter put the data last. That's fine, because you can just use >>. Alternatively you can wrap and rename the procedure, which is what we've done for these functions:

    original   data-first version
    -----------------------------
    for-each   iterate

example:

    > ('(1 2 3) → iterate (x : displayln x))
    1
    2
    3

## Comparison to Clojure's Threading Macro

Clojure's threading macro is a prefix operator, which means it is less readable when nested and requires more parentheses. You could say that the *fluent* infix operator acts as one parenthesis. Compare:

CLOJURE (prefix): 

    (-> (list (-> (-> id3 (hash-ref 'genre "unknown")) normalise-field)
              (-> (-> id3 (hash-ref 'track "0")) normalise-field)
              (-> (-> id3 (hash-ref 'artist "unknown")) normalise-field)
              (-> (-> id3 (hash-ref 'title "unknown")) normalise-field)) (string-join "."))

FLUENT (infix):

    (list (id3 → hash-ref 'genre "unknown" → normalise-field)
          (id3 → hash-ref 'track "0" → normalise-field)
          (id3 → hash-ref 'artist "unknown" → normalise-field)
          (id3 → hash-ref 'title "unknown" → normalise-field)) → string-join ".")
 
## How to enter → with your keyboard

→ is Unicode character 2192. On linux you can enter this using `shift-ctrl-u 2192 enter`. Naturally, if you want to use this character, you should map it to some unused key on your keyboard. This can be done with xmodmap:

    # use xev to get the keycode
    $ xev

    # check the current mapping
    $ xmodmap -pke

    # replace the mapping
    $ xmodmap -e "keycode 51=U2192 Ccedilla ccedilla Ccedilla braceright breve braceright"

Making this change permanent depends on your session manager. Search duckduckgo for details.

## Installation

This library will soon be available on the racket package server.

## Related Resources

For more solutions to your life's problems, [visit the author's website](https://rogerkeays.com)

