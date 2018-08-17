#! /usr/bin/gst -f


| N OP result |


Object subclass: #Computer.
Computer class extend [
    sumTo: n [
        | result |
        result := 0.
        1 to: n do: [:x | result := result + x].
        ^result
    ]

    productTo: n [
        | result |
        result := 1.
        1 to: n do: [:x | result := result * x].
        ^result
    ]
]


'Please, choose a number:' displayNl.
N := stdin nextLine asInteger.

'Please, choose an operation (''+'' or ''*'')' displayNl.
OP := stdin nextLine.

(OP = '+')
    ifTrue: [ result := Computer sumTo: N ]
    ifFalse: [ result := Computer productTo: N].

'Your estimated value is: ' display.
result displayNl.
