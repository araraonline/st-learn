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

    MyArray class >> displayConcatWith: arr1 and: arr2 [
        | result |
        result := arr1 concatenateTo: arr2.
        'Array 1: ' display.
        arr1 displayNl.
        'Array 2: ' display.
        arr2 displayNl.
        'Concatenated: ' display.
        result displayNl.
        '' displayNl
    ]

    concatenateTo: arr [
        "Answer with a new instance of MyArray, containing 
         the elements of the receiver followed by the elements of
         arr"
        
        | ret ws |
        ret := MyArray new: self size + arr size.
        ws := WriteStream on: ret.
        ws nextPutAll: self.
        ws nextPutAll: arr.
        ^ret
    ]
]


MyArray
    displayConcatWith: (MyArray from: #())
    and: (MyArray from: #()).
MyArray
    displayConcatWith: (MyArray from: #(1 2))
    and: (MyArray from: #()).
MyArray
    displayConcatWith: (MyArray from: #())
    and: (MyArray from: #(1 2)).
MyArray
    displayConcatWith: (MyArray from: #(3 4))
    and: (MyArray from: #(1 2))
