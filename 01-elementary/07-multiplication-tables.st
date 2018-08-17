#! /usr/bin/gst -f


Object subclass: MultiplicationTable [
    | factor |

    MultiplicationTable class >> new [
        ^self error: 'Please use #of: instead of #new'
    ]

    MultiplicationTable class >> of: n [
        ^(super new) setFactor: n; yourself
    ]

    setFactor: n [
        factor := n
    ]

    displayOn: stream [
        | NUM1 NUM2 PRODUCT |

        'Multiplication table of ' displayOn: stream.
        factor displayOn: stream.
        ':' displayOn: stream.
        stream nl.

        1 to: 12 do: [:x |
            NUM1 := factor.
            NUM2 := x.
            PRODUCT := NUM1 * NUM2.

            NUM1 displayOn: stream.
            'x' displayOn: stream.
            NUM2 displayOn: stream.
            ' = ' displayOn: stream.
            PRODUCT displayOn: stream.
            stream nl.
        ]
    ]
]


1 to: 12 do: [:x | (MultiplicationTable of: x) displayNl ]
