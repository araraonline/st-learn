#! /usr/bin/gst -f


Array subclass: MyArray [

    <shape: #inherit>

    MyArray class >> from: array [
        "Answer with a new SortedArray, whose elements will be the
         same as array, but sorted."

        <category: 'instance creation'>
        | instance ws |
        instance := self new: array size.
        ws := WriteStream on: instance.
        ws nextPutAll: (array sorted).
        ^instance
    ]

    from: index1 to: index2 [
        "Answers with a new array containing elements from index1
         to index2."

        <category: 'slicing'>
        | array |
        array := MyArray new: (index2 - index1 + 1).
        index1
            to: index2
            do: [:index |
                 array at: (index - index1 + 1) put: (self at: index)].
        ^array
    ]

    from: index1 to: index2 putAll: array [
        "Replace elements from index1 to index2 to elements
         inside array."

        <category: 'slicing'>
        index1
            to: index2
            do: [:index |
                 self at: index put: (array at: index - index1 + 1)]
    ]

    moveElementFrom: index1 to: index2 [
        "Copy element from index1 to index2"

        <category: 'internals'>
        self at: index2 put: (self at: index1)
    ]


    rotate: k [
        "Rotate myself k units to the left. As asked by the exercise,
         the number of movement operations is u + (s - u) + u = s + u,
         where s is the size of the array and u = k \\ s ('\\' is the
         modulus operator"

        <category: 'homework'>
        | size units waiting |
        size := self size.
        units := k \\ size.
        waiting := self from: 1 to: units.
        units + 1
            to: size
            do: [:i | self moveElementFrom: i to: i - units].
        self from: size - units + 1 to: size putAll: waiting.
    ]

    displayRotate: k [
        'Array: ' display.
        self displayNl.
        'Rotate ' display.
        k display.
        ': ' display.
        self rotate: k.
        self displayNl.
        Transcript nl
    ]
]

(MyArray from: #(1 2 3 4 5 6)) displayRotate: 2.
(MyArray from: #(1 2 3)) displayRotate: 0.
(MyArray from: #(1 2 3)) displayRotate: 1.
(MyArray from: #(1 2 3)) displayRotate: 2.
(MyArray from: #(1 2 3)) displayRotate: 3.
(MyArray from: #(1 2 3)) displayRotate: -1
