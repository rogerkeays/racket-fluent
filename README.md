
# fluent

UNIX style pipes and a lambda shorthand syntax to make your Racket code more readable.

## ? Unpopular So LISP Is Why

Let's be honest. LISP missed a huge opportunity to change the world by telling developers they have to think backwards. Meanwhile, UNIX became successful largely because it allows you to compose programs sequentially using pipes. Compare the difference (the LISP example is Racket code):

    UNIX: cat data.txt | grep "active" | sort | uniq
    LISP: (remove-duplicates (sort ((filter (λ (line) (string-contains? line "active")) (file->lines "data.txt")))))

Using *fluent*, the same Racket code can be written according to the UNIX philosophy:

    ("data.txt" ~> file->lines ~~> filter (line : line ~> string-contains? "active") ~> sort ~> remove-duplicates)

If you don't like this syntax, *fluent* allows you to define your own operators or choose from some predefined alternatives. E.g:

    ("data.txt" → file->lines ⇒ filter (line : line → string-contains? "active") → sort → remove-duplicates)

## Function Composition

Using the function composition operator (~>), *fluent* inserts the left hand side as the first parameter to the procedure on the right hand side. Use ~~> to add the left hand side as the last parameter to the procedure.

    (data ~> procedure params)     becomes    (procedure data params)
    (data ~~> procedure params)    becomes    (procedure params data)

This operation can be chained or nested as demonstrated in the examples.

## Lambda Shorthand

The : operator allows you to easily write a lambda function with one expression. Parameters go on the left, the expression on the right, no parentheses required. For example:

    > ((x : + x 1) 1)
    2
    > ((x y : + x y) 1 2)
    3
    > (map (x : string-upcase x) '("a" "b" "c"))
    '("A" "B" "C")

## Flexible Syntax

If you don't like the default operators, you can rename then using (rename-in):

    (require fluent (rename-in (~> >) (~~> >>)))
    ("hello world" > string-upcase > string-split) ;; '("HELLO" "WORLD")

*fluent* comes with two built in alternative syntaxes, `fluent/short` (which uses `>` and `>>` and `fluent/unicode` which uses `→` and `⇒`):

    (require fluent/short)
    ("hello world" > string-split >> map string-upcase) ;; '("HELLO" "WORLD")

    (require fluent/unicode)
    ("hello world" → string-split ⇒ map string-upcase) ;; '("HELLO" "WORLD")

→ is Unicode character 2192. On linux you can enter this using `shift-ctrl-u 2192 enter`. ⇒ is 21D2. Naturally, if you want to use these characters, you should map it to some unused key on your keyboard. This can be done with xmodmap:

    # use xev to get the keycode
    $ xev

    # check the current mapping
    $ xmodmap -pke

    # replace the mapping
    $ xmodmap -e "keycode 51=U2192 U21D2 ccedilla Ccedilla braceright breve braceright"

This maps the cedilla key to →, and shift-cedilla to ⇒. You could use the menu key, window key, pause, insert, caps lock, or any othe useless key on your keyboard. Making this change permanent depends on your session manager. Search duckduckgo for details.

## Convenience Procedures

When using function composition, procedures with text names are easier to read. For this reason, *fluent* provides the following alternative names for the common base math procedures.

    > gt?
    < lt?
    >= gte?
    <= lte?
    + add
    - subtract
    * multiply
    / divide

Compare:

    (1 ~> + 1 ~> * 2 ~> >= 3)
    (1 ~> add 1 ~> multiply 2 ~> gte? 3)

Of course, the choice is yours. Note, if you use *fluent/short* you will need to use `gt?` for the math procedure, as `>` is used for function composition.

*fluent* also works best with procedures which place the data (input) parameter first. Most racket functions do this out of the box, but many functions which take a procedure as a parameter put the data last. That's fine, because you can just use `~~>`. Alternatively you can wrap and rename the procedure, which is what we've done for these functions:

    original   data-first version
    -----------------------------
    for-each   iterate

example:

    > ('(1 2 3) ~> iterate (x : displayln x))
    1
    2
    3

## Comparison to Clojure's Threading Macro

*fluent* uses infix operators which has three main advantages over other prefix macros you'll find for Clojure, Racket and LISP. Firstly, you can combine `~>` and `~~>` just fine without using any ugly hacks:

    ("hello world" ~> string-upcase ~~> regexp-match? #px"LL" ~> eq? #t)

Secondly, you don't need to put parentheses around procedures that take additional parameters. You can see this at work in the last two functions in the example above and in the example below. Finally, infix operators make nested code easier to follow. Compare:

CLOJURE (prefix): 

    (-> (list (-> id3 (hash-ref 'genre "unknown"))
              (-> id3 (hash-ref 'track "0"))
              (-> id3 (hash-ref 'artist "unknown"))
              (-> id3 (hash-ref 'title "unknown")))
        (string-join "."))

FLUENT (infix):

    (list (id3 ~> hash-ref 'genre "unknown")
          (id3 ~> hash-ref 'track "0")
          (id3 ~> hash-ref 'artist "unknown")
          (id3 ~> hash-ref 'title "unknown")) ~> string-join ".")

And of course, with *fluent* you can use your own syntax.

## Installation

This library is available from the Racket package collection and can be installed with raco:

    $ raco pkg install fluent

All you need to do is `(require fluent)`. You can try it out in the REPL:

    > (require fluent)
    > ("FOO" ~> string-downcase)
    "foo"
    > ((x y : x ~> add y) 1 2)
    3

## Known Issues

The function composition operator is not compatible with the `and` and `or` macros. *fluent* provides wrapper `&&` and `||` procedures which work with two arguments. 

## Related Resources

For more solutions to your life's problems, [visit the author's website](https://rogerkeays.com)

