#! /usr/bin/gst -f


Array subclass: MyArray [
    
    <shape: #inherit>

    MyArray class >> random [
        "Return a random array of integers"

        <category: 'testing'>
        | size array |
        size := Random between: 0 and: 100.
        array := self new: size.
        1 to: size do: [:i |
            | value |
            value := Random between: -1000 and: 1000.
            array at: i put: value
        ].
        ^array
    ]

    swap: index1 with: index2 [
        "Swap elements from index1 and index2"

        <category: 'basic'>
        | toIndex1 toIndex2 |
        toIndex1 := self at: index2.
        toIndex2 := self at: index1.
        self at: index1 put: toIndex1.
        self at: index2 put: toIndex2
    ]

    minimumIndexFrom: index1 to: index2 [
        "Return the minimum argument index from index1 to index2"

        <category: 'array summary'>
        | curMinValue curMinPos |
        curMinValue := self at: index1.
        curMinPos := index1.
        index1 + 1 to: index2 do: [:i |
            | value |
            value := self at: i.
            value < curMinValue
                ifTrue: [curMinValue := value.
                         curMinPos := i]
        ].
        ^curMinPos
    ]
]

Object subclass: Sorter [

    <comment: 'I will sort arrays based on different
methods. All my methods will return new arrays instead
of modifying the original array (if the algorithm
works inplace, I will create a copy of the array
first).'>

    baseSort: array [
        "This is a copy of the GNU Smalltalk sorting
         algorithm. We don't know how they do it."

        <category: 'testing'>
        ^array sorted
    ]

    selectionSort: array [
        "Answer with a sorted array, based on the
         selection sort algorithm."

        <category: 'homework'>
        | arr |
        arr := array copy.
        1 to: arr size - 1 do: [:i |
            arr
                swap: (arr minimumIndexFrom: i to: arr size)
                with: i
        ].
        ^arr
    ]

    tests [
        "Compare the result of sorting algorithms
         with the basic Smalltalk implementation."

        <category: 'testing'>
        100 timesRepeat: [
            | array sorted selectionSorted |
            array := MyArray random.
            sorted := self baseSort: array.
            selectionSorted := self selectionSort: array.

            sorted ~= selectionSorted
                ifTrue: [self error: 'selection sort didn''t work'].
        ].
        'tests okay!' displayNl
    ]
]

Sorter new tests.