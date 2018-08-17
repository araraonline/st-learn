#! /usr/bin/gst -f


Object subclass: #Maths.
Maths class extend [
    num: x isdivisible: y [
        ^x \\ y = 0
    ]
]

| sum N |

'Enter your number:' displayNl.
N := stdin nextLine asInteger.

sum := 0.
1 to: N do: [:x | 
    ((Maths num: x isdivisible: 3) |
     (Maths num: x isdivisible: 5))
        ifTrue: [sum := sum + x]
].

'The sum of multiples of 3 or 5 from 1 to ' display.
N display.
' is: ' display.
sum displayNl
