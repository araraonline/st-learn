#! /usr/bin/gst -f


Array subclass: MyArray [
    <shape: #inherit>

    contains: elem [
        self do: [:x | (x = elem) ifTrue: [^true]].
        ^false
    ]
]

arr := MyArray new: 5.
s := WriteStream on: arr.
s nextPutAll: {1 .2 .3 .4 .5}.

'Array: ' display.
arr displayNl.
(arr contains: 2) ifTrue: ['2 in array' displayNl] ifFalse: ['2 not in array' displayNl].
(arr contains: 8) ifTrue: ['8 in array' displayNl] ifFalse: ['8 not in array' displayNl]
