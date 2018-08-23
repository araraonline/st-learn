#! /usr/bin/gst -f


Object subclass: Digitizer [
    Digitizer class >> digitize: number [
        "Answer with a list of digits representing a positive 
         integer number."
        
        <category: 'homework'>
        | result n |
        (number < 0) ifTrue: [self error: 'number must be positive'].
        result := WriteStream on: Array new.
        n := number.
        [n ~= 0] whileTrue: [
            result nextPut: (n \\ 10).
            n := n // 10
        ].
        ^result reverseContents
    ]

    Digitizer class >> showcase [
        | numbers |
        numbers := #(1 12 123 2342).
        numbers do: [:x |
            x display.
            ' -> ' display.
            (self digitize: x) displayNl
        ]
    ]
]

Digitizer showcase
