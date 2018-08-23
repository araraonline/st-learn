#! /usr/bin/gst -f


| a b c fibonacciGenerator |
a := 1.
b := 1.
fibonacciGenerator := Generator on: [:gen |
    [true] whileTrue: [
        gen yield: a.
        c := a + b.
        a := b.
        b := c
    ]
].
'The first 100 fibonacci:' displayNl.
Transcript nl.
(fibonacciGenerator next: 100) do: [:x | x displayNl]
