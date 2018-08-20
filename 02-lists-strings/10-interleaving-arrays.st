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
    | arr1 arr2 curArray curIndex maxIndex firstBigger |

    InterleavingStream class >> from: array1 and: array2 [
        ^(super new)
            init;
            setFirst: array1;
            setSecond: array2;
            initArrays;
            yourself
    ]

    init [
        curArray := 1.
        curIndex := 1
    ]

    setFirst: array [
        arr1 := MyArray from: array
    ]

    setSecond: array [
        arr2 := MyArray from: array
    ]

    initArrays [
        maxIndex := (arr1 size) max: (arr2 size).
        firstBigger := (arr1 size) > (arr2 size)
    ]

    next [
        | ret block |
        block := [
            (curArray = 1) "Retrieve value"
                ifTrue: [ret := arr1 at: curIndex withDefault: nil]
                ifFalse: [ret := arr2 at: curIndex withDefault: nil].

            (curArray = 1)  "Update index"
                ifTrue: [curArray := 2]
                ifFalse: [curArray := 1. curIndex := curIndex + 1].
        ].
        [ret isNil] whileTrue: block.
        ^ret
    ]

    atEnd [
        ^(firstBigger & (curIndex = maxIndex) & (curArray = 2)) |
         (curIndex > maxIndex)
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
