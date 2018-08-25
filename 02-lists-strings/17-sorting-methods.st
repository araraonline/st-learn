#! /usr/bin/gst -f


Array subclass: MyArray [
    
    <shape: #inherit>

    MyArray class >> from: anotherArray [
        | instance |
        instance := self new: anotherArray size.
        anotherArray nextPutAllOn: instance writeStream.
        ^instance
    ]

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

    insertionSort: array [
        "Answer with a sorted array, based on the
         insertion sort algorithm."

        <category: 'homework'>
        | arr |
        arr := array copy.
        2 to: arr size do: [:i |
            | value j |
            value := arr at: i.
            j := i - 1.
            [(j >= 1) and: [(arr at: j) > value]] whileTrue: [
                arr swap: j with: j + 1.
                j := j - 1
            ].
            j := j + 1.
            arr at: j put: value
        ].
        ^arr
    ]

    mergeSort: array [
        "Answer with a sorted array, based on the
         merge sort algorithm."

        <category: 'homework'>
        | arr1 arr2 cutPoint |
        array size <= 1 ifTrue: [^array copy].
        cutPoint := array size + 1 // 2.
        arr1 := array copyFrom: 1 to: cutPoint.
        arr2 := array copyFrom: cutPoint + 1 to: array size.
        ^self merge: (self mergeSort: arr1) with: (self mergeSort: arr2)
    ]

    merge: array1 with: array2 [
        "Answer with a new array, containing elements of
         both array1 and array2 in sorted order. I assume
         that both arrays are sent in sorted"

        <category: 'helper'>
        | rs1 rs2 ws |
        ws := WriteStream on: MyArray new.
        rs1 := array1 readStream.
        rs2 := array2 readStream.
        [ rs1 atEnd | rs2 atEnd ] whileFalse: [
            rs1 peek <= rs2 peek
                ifTrue: [ws nextPut: rs1 next]
                ifFalse: [ws nextPut: rs2 next]
        ].

        ws nextPutAll: rs1.
        ws nextPutAll: rs2.

        ^ws contents
    ]

    tests [
        "Compare the result of sorting algorithms
         with the basic Smalltalk implementation."

        <category: 'testing'>
        100 timesRepeat: [
            | array sorted selectionSorted insertionSorted mergeSorted |
            array := MyArray random.
            sorted := self baseSort: array.
            selectionSorted := self selectionSort: array.
            insertionSorted := self insertionSort: array.
            mergeSorted := self mergeSort: array.

            sorted ~= selectionSorted
                ifTrue: [self error: 'selection sort didn''t work'].
            sorted ~= insertionSorted
                ifTrue: [self error: 'insertion sort didn''t work'].
            sorted ~= mergeSorted
                ifTrue: [self error: 'merge sort didn''t work'].
        ].
        'tests okay!' displayNl
    ]
]

Sorter new tests.
