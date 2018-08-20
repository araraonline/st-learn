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

    at: index withDefault: value [
        "When index is out of bounds, answer with value"
        (index < 0) | (index > self size)
            ifTrue: [^value]
            ifFalse: [^self at: index]
    ]
]

Stream subclass: InterleavingStream [
    | arr1 arr2 curArray curIndex maxIndex |

    <comment: 'I''m a stream made up of two arrays, glued
together in an interleaved way. When one array is bigger than
the other, I will assume the smaller one is filled with nils,
so that I can do my job in an easier manner.'>

    InterleavingStream class >> from: array1 and: array2 [
        ^(super new)
            initFrom: array1 and: array2;
            yourself
    ]

    initFrom: array1 and: array2 [
        curArray := 1.
        curIndex := 1.
        arr1 := MyArray from: array1.
        arr2 := MyArray from: array2.
        maxIndex := (arr1 size) max: (arr2 size).
    ]

    next [
        | ret |
        (curArray = 1) "Retrieve value"
            ifTrue: [ret := arr1 at: curIndex withDefault: nil]
            ifFalse: [ret := arr2 at: curIndex withDefault: nil].

        (curArray = 1)  "Update index"
            ifTrue: [curArray := 2]
            ifFalse: [curArray := 1. curIndex := curIndex + 1].
        ^ret
    ]

    atEnd [
         ^(curIndex > maxIndex)
    ]

    displayWorkings [
        'Array 1: ' display.
        arr1 displayNl.
        'Array 2: ' display.
        arr2 displayNl.
        'Interleaving: ' display.
        self upToEnd displayNl.
        '' displayNl.
    ]
]


(InterleavingStream from: #() and: #()) displayWorkings.
(InterleavingStream from: #(1) and: #()) displayWorkings.
(InterleavingStream from: #() and: #(11)) displayWorkings.
(InterleavingStream from: #(1 2 3) and: #(11 12 13)) displayWorkings.
(InterleavingStream from: #(1 2) and: #(11 12 13 14)) displayWorkings.
(InterleavingStream from: #(1 2 3 4) and: #(11 12)) displayWorkings
