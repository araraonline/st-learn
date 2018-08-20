#! /usr/bin/gst -f


Array subclass: MyArray [
    
    <shape: #inherit>

    MyArray class >> from: arr [
        | instance ws |
        instance := self new: arr size.
        ws := WriteStream on: instance.
        ws nextPutAll: arr.
        ^instance
    ]

    sum1 [
        | ret |
        ret := 0.
        self do: [:x | ret := ret + x].
        ^ret
    ]

    sum2 [
        | index ret |
        index := 1.
        ret := 0.
        [index <= self size]
            whileTrue: [ret := ret + (self at: index). index := index + 1].
        ^ret
    ]

    sum3 [
        ^self sumFromPos: 1 
    ]

    sumFromPos: i [
        (i > self size)
            ifTrue:  [^0]
            ifFalse: [^(self at: i) + (self sumFromPos: i + 1)]
    ]

    showSums [
        self displayNl.

        'sum1: ' display.
        self sum1 displayNl.

        'sum2: ' display.
        self sum2 displayNl.

        'sum3: ' display.
        self sum3 displayNl.

        '' displayNl.
    ]
]


arr := MyArray from: #().
arr showSums.

arr := MyArray from: #(1 2 3).
arr showSums.

arr := MyArray from: #(1 2 3 4).
arr showSums.
