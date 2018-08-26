#! /usr/bin/gst -f


Object subclass: Framer [
    <comment: 'I print list of strings surrounded by
frames of stars'>

    printFrame: listOfStrings [
        "Print a frame containing all strings!"

        <category: 'homework'>
        | innerSize outerSize |
        
        innerSize := self getInnerSize: listOfStrings.
        outerSize := innerSize + (2 * self borderSize).

        outerSize timesRepeat: [self printStar].
        self nl.
        listOfStrings do: [:string |
            self printStar.
            self printSpace.
            self printString: string.
            (innerSize - string size + 1) timesRepeat: [self printSpace].
            self printStar.
            self nl.
        ].
        outerSize timesRepeat: [self printStar].
        self nl.
    ]

    getInnerSize: listOfStrings [
        "Retrieve the inner frame size"

        <category: 'private'>
        | maxSize |
        maxSize := 0.
        listOfStrings do: [:s | s size > maxSize ifTrue: [maxSize := s size]].
        ^maxSize
    ]

    borderSize [
        "Respond with the used border size"

        <category: 'private'>
        ^2
    ]

    printStar [
        "Print a star to the output"

        <category: 'private'>
        '*' display
    ]

    printSpace [
        "Print a space to the output"

        <category: 'private'>
        ' ' display
    ]
    
    printString: string [
        "Print a string to the output"

        <category: 'private'>
        string display
    ]

    nl [
        "Print a newline to the output"

        <category: 'private'>
        Transcript nl
    ]
]

Framer new printFrame: #('Hello' 'World' 'in' 'a' 'frame').
Framer new printFrame: #('' '' 'AAAA')
