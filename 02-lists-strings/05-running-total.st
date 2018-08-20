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

    runningTotal [
        "Generates a new array that is the running total of this one"

        | partial ret ws |
        ret := MyArray new: self size.
        ws := WriteStream on: ret.        
        partial := 0.
        self do: [:x |
            partial := partial + x.
            ws nextPut: partial
        ].
        ^ret
    ]
]

arr := MyArray from: #(1 2 3 4).
running := arr runningTotal.

'Original array: ' display.
arr displayNl.

'Running total: ' display.
running displayNl
