#! /usr/bin/gst -f


SortedCollection extend [
    SortedCollection class >> from: array [
        "Answer with a new SortedColletion with
         the elements present in array"

        <category: 'instance creation'>
        | instance |
        instance := self new: array size.
        array do: [:x | instance add: x].
        ^instance
    ]

    SortedCollection class >> random [
        "Return a random SortedCollection of integers"

        <category: 'instance creation'>
        | size instance |
        size := Random between: 0 and: 100.
        instance := self new: size.
        1 to: size do: [:i |
            | value |
            value := Random between: -30 and: 30.
            instance add: value
        ].
        ^instance
    ]

    SortedCollection class >> testBinarySearch [
        <category: 'tests'>

        'Testing removed elements...' displayNl.
        [
            | instance |
            instance := self from: #(1 2 3 4 5 6 7 8 9 10).
            instance copy do: [:x |
                instance remove: x.
                (instance binarySearch: x) isNil
                    ifFalse: [self error: 'found element that was not present'].
                instance add: x
            ]
        ] value.

        'Testing random arrays...' displayNl.
        1000 timesRepeat: [
            | instance |
            instance := self random.
            instance do: [:x |
                | index |
                index := instance binarySearch: x.
                (instance at: index) ~= x
                    ifTrue: [self error: 'found bad index for item ', x asString].
                (instance binarySearch: -50) isNil
                    ifFalse: [self error: 'found -50 where it was not present'].
                (instance binarySearch: 50) isNil
                    ifFalse: [self error: 'found 50 where it was not present']
            ]
        ].

        'Tests okay!' displayNl.
    ]

    binarySearch: value [
        "Search for the index of value using binary search.
         If value can't be found, I will return nil."

        <category: 'homework'>
        ^self binarySearch: value from: 1 to: self size
    ]

    binarySearch: target from: start to: end [
        "Search for the index of target between the given
         indices. If it can't be found, I will return nil."

        <category: 'private'>
        | midpoint midpointValue |
        start = end ifTrue: [(self at: start) = target ifTrue: [^start] ifFalse: [^nil]].
        start > end ifTrue: [^nil].
        midpoint := (start + end / 2) floor.
        midpointValue := self at: midpoint.
        target < midpointValue ifTrue: [^self binarySearch: target from: start to: midpoint - 1].
        target > midpointValue ifTrue: [^self binarySearch: target from: midpoint + 1 to: end].
        ^midpoint
    ]
]

SortedCollection testBinarySearch
