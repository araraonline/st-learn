#! /usr/bin/gst -f


Array subclass: SortedArray [

    <comment: 'I''m an array whose elements are sorted.'>
    <shape: #inherit>

    SortedArray class >> from: array [
        "Answer with a new SortedArray, whose elements will be the
         same as array, but sorted."

        | instance ws |
        instance := self new: array size.
        ws := WriteStream on: instance.
        ws nextPutAll: (array sorted).
        ^instance
    ]

    SortedArray class >> displayMergeWith: array1 and: array2 [
        "Demonstrate the merging of two arrays using the mergeWith:
         message"

        | arr1 arr2 merged |
        arr1 := self from: array1.
        arr2 := self from: array2.
        merged := arr1 mergeWith: arr2.
        'Array 1: ' display.
        arr1 displayNl.
        'Array 2: ' display.
        arr2 displayNl.
        'Merged: ' display.
        merged displayNl.
        Transcript nl
    ]

    mergeWith: anotherArray [
        "Merge this array with anotherArray, keeping the order of
         the elements. The receiver will emit a new array."

        | ret rs1 rs2 ws v1 v2 |
        ret := SortedArray new: self size + anotherArray size.
        rs1 := ReadStream on: self.
        rs2 := ReadStream on: anotherArray.
        ws := WriteStream on: ret.

        "Edge cases"
        rs2 atEnd ifTrue: [ws nextPutAll: rs1. ^ret].
        rs1 atEnd ifTrue: [ws nextPutAll: rs2. ^ret].

        "Core"
        v1 := rs1 next.
        v2 := rs2 next.
        [rs1 atEnd | rs2 atEnd]
            whileFalse: [(v1 <= v2)
                             ifTrue:  [ws nextPut: v1. v1 := rs1 next]
                             ifFalse: [ws nextPut: v2. v2 := rs2 next]].

        "Conclude"
        ws
            nextPut: (v1 min: v2);
            nextPut: (v1 max: v2);
            nextPutAll: rs1;
            nextPutAll: rs2.

        ^ret
    ]
]


SortedArray displayMergeWith: #() and: #(1 2).
SortedArray displayMergeWith: #(1 2) and: #().
SortedArray displayMergeWith: #(2) and: #(1 3).
SortedArray displayMergeWith: #(1 3) and: #(2).
SortedArray displayMergeWith: #(1 4 6) and: #(2 3 5)
