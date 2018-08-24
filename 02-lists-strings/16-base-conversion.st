#! /usr/bin/gst -f


Object subclass: BaseConverter [
    | digitsDict |
    
    <comment: 'I will perform the conversion of numbers from on base
to the other. My numbers are represented as strings, in which digits
higher than 9 are represented by the letters A to Z.'>

    convert: number fromBase: base1 toBase: base2 [
        "Convert number from base base1 to base base2. Number is represented
         as a string of characters [0-9A-Z]"

        <category: 'homework'>
        | integer newNumber |
        integer := self read: number in: base1.
        newNumber := self write: integer in: base2.
        ^newNumber
    ]

    baseConvert: number fromBase: base1 toBase: base2 [
        "Convert number from base base1 to base base2. Number is represented
         as a string of characters [0-9A-Z]. This uses functionality already
         present in GNU's Smalltalk."

        <category: 'homework'>
        | integer newNumber |
        integer := Integer readFrom: (ReadStream on: number) radix: base1.
        newNumber := integer printString: base2.
        ^newNumber
    ]

    read: string in: base [
        "Answer with an Integer representing string in the given base."

        <category: 'basic'>
        | result partResult |
        result := 0.
        string size to: 1 by: -1 do: [:pos |
            partResult := (string at: pos) digitValue.
            partResult := partResult * (base raisedToInteger: string size - pos).
            result := result + partResult
        ].
        ^result
    ]

    write: integer in: base [
        "Answer with a String representing integer in base."

        <category: 'basic'>
        | results temp |
        results := WriteStream on: String new.
        temp := integer.
        [temp ~= 0] whileTrue: [
            results nextPut: (Character digitValue: temp \\ base).
            temp := temp // base
        ].
        ^results reverseContents        
    ]

    test [
        "Test 1000 random examples of conversion"

        <category: 'test'>
        1000 timesRepeat: [
            | number string base1 base2 |
            number:= Random between: 0 and: 10000.
            base1 := Random between: 2 and: 36.
            base2 := Random between: 2 and: 36.
            string := number printString: base1.
            self testConvert: string fromBase: base1 toBase: base2.
        ].
        'tests okay!' displayNl.
    ]

    testConvert: number fromBase: base1 toBase: base2 [
        "Test 1 conversion, comparing the written algorithm with
         the one almost present in GNU Smalltalk."

        <category: 'test'>
        | conversion1 conversion2 |
        conversion1 := self convert: number fromBase: base1 toBase: base2.
        conversion2 := self baseConvert: number fromBase: base1 toBase: base2.
        conversion1 ~= conversion2
            ifTrue: [|eStream|
                     eStream := WriteStream on: String new.
                     'Could not convert ' displayOn: eStream.
                     number printOn: eStream.
                     ' from base ' displayOn: eStream.
                     base1 displayOn: eStream.
                     ' to base ' displayOn: eStream.
                     base2 displayOn: eStream.
                     ' (found: ' displayOn: eStream.
                     conversion1 printOn: eStream.
                     ' expected: ' displayOn: eStream.
                     conversion2 printOn: eStream.
                     ')' displayOn: eStream.
                     self error: eStream contents]
    ]
]


BaseConverter new test
