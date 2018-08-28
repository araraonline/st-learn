#! /usr/bin/gst -f


genBlock := [:gen |
    "I will use base 3 numbers to generate expressions...

     For example, the number '000' would mean there is no
     operator between the numbers. '111', otherwise, would
     represent three addition operators (1+2+3)."

    0 to: (3 raisedToInteger: 8) - 1 do: [:num |
        | expr i |
        expr := '1'.
        i := 2.
        (num printPaddedWith: $0 to: 8 base: 3) do: [:digit |
            digit = $1 ifTrue: [expr := expr , '+'].
            digit = $2 ifTrue: [expr := expr , '-'].

            expr := expr , i asString.
            i := i + 1.
        ].
        gen yield: expr
    ]
].

"Generate the expressions needed
 and evaluate them. If the result
 is 100, print the expression"
exprGenerator := Generator on: genBlock.
exprGenerator do: [:expr |
    | value |
    value := Behavior evaluate: expr.
    value = 100 ifTrue: [expr displayNl]
]
