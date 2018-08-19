#! /usr/bin/gst -f


Array subclass: MyArray [

    <shape: #inherit>

    oddArray [
        "Generate a new array with only the odd positioned elements"
        | ret ws |
        ret := MyArray new: ((self size + 1) // 2).
        ws := WriteStream on: ret.
        1 to: self size by: 2 do: [:i | ws nextPut: (self at: i)].
        ^ret
    ]
]


"Case 1"
arr := MyArray new: 8.
ws := WriteStream on: arr.
ws nextPutAll: #(1 2 3 4 5 6 7 8).

'Array: ' display.
arr displayNl.
'Array at odd positions: ' display.
(arr oddArray) displayNl.
'' displayNl.


"Case 2"
arr := MyArray new: 7.
ws := WriteStream on: arr.
ws nextPutAll: #(1 2 100 4 5 6 7).

'Array: ' display.
arr displayNl.
'Array at odd positions: ' display.
(arr oddArray) displayNl.
'' displayNl.
