#! /usr/bin/gst -f


Object subclass: Interleaver [

    <comment: 'I will interleave arrays that are passed to me'>

    interleave: arr1 and: arr2 [
        "Interleaves arr1 and arr2 into a new array"

        | block |
        block := [:gen |
            1
                to: ((arr1 size) max: (arr2 size))
                do: [:i |
                     (i <= arr1 size) ifTrue: [gen yield: (arr1 at: i)].
                     (i <= arr2 size) ifTrue: [gen yield: (arr2 at: i)]]
        ].
        ^(Generator on: block) upToEnd
    ]

    displayWorkingsWith: arr1 and: arr2 [
        'Array 1: ' display.
        arr1 displayNl.
        'Array 2: ' display.
        arr2 displayNl.
        'Interleaving: ' display.
        (self interleave: arr1 and: arr2) displayNl.
        '' displayNl
    ]
]


interleaver := Interleaver new.
interleaver displayWorkingsWith: #() and: #().
interleaver displayWorkingsWith: #(1) and: #().
interleaver displayWorkingsWith: #() and: #(11).
interleaver displayWorkingsWith: #(1 2 3) and: #(11 12 13).
interleaver displayWorkingsWith: #(1 2) and: #(11 12 13 14).
interleaver displayWorkingsWith: #(1 2 3 4) and: #(11 12)
