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

    apply: aBlock at: index [
        "Apply aBlock to element at index"
        | original transformed |
        original := self at: index.
        transformed := aBlock value: original.
        self at: index put: transformed
    ]

    applyOnAll: aBlock [
        "This is equivalent to collect:, but acts in place"
        1
            to: self size
            do: [:i | self apply: aBlock at: i]
    ]

    displaySquares [
        "Raise all elements to the square"
        "Show before and after"

        <category: 'printing'>
        'Before squaring: ' display.
        self displayNl.
        
        self applyOnAll: [:x | x * x].
        
        'After squaring: ' display.
        self displayNl.        
        '' displayNl.
    ]
]


(MyArray from: #()) displaySquares.
(MyArray from: #(1 2 3)) displaySquares.
(MyArray from: #(1 2 3 4)) displaySquares.
