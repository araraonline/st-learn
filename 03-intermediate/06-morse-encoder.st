#! /usr/bin/gst -f


Dictionary extend [
    reverse [
        "Answer with a new dictionary, whose keys are equivalent
         to my values, and whose values are equivalent to my keys"

        <category: 'misc'>
        | result |
        result := self class new.
        self keysAndValuesDo: [:key :value | result at: value put: key].
        ^result
    ]
]


"Create a dictionary that links
characters into their morse code"

morseTable := LookupTable new.
morseTable at: $a put: '.-'.
morseTable at: $b put: '-...'.
morseTable at: $c put: '-.-.'.
morseTable at: $d put: '-..'.
morseTable at: $e put: '.'.
morseTable at: $f put: '..-.'.
morseTable at: $g put: '--.'.
morseTable at: $h put: '....'.
morseTable at: $i put: '..'.
morseTable at: $j put: '.---'.
morseTable at: $k put: '-.-'.
morseTable at: $l put: '.-..'.
morseTable at: $m put: '--'.
morseTable at: $n put: '-.'.
morseTable at: $o put: '---'.
morseTable at: $p put: '.--.'.
morseTable at: $q put: '--.-'.
morseTable at: $r put: '.-.'.
morseTable at: $s put: '...'.
morseTable at: $t put: '-'.
morseTable at: $u put: '..-'.
morseTable at: $v put: '...-'.
morseTable at: $w put: '.--'.
morseTable at: $x put: '-..-'.
morseTable at: $y put: '-.--'.
morseTable at: $z put: '--..'.
morseTable at: $0 put: '-----'.
morseTable at: $1 put: '.----'.
morseTable at: $2 put: '..---'.
morseTable at: $3 put: '...--'.
morseTable at: $4 put: '....-'.
morseTable at: $5 put: '.....'.
morseTable at: $6 put: '-....'.
morseTable at: $7 put: '--...'.
morseTable at: $8 put: '---..'.
morseTable at: $9 put: '----.'.
morseTable at: $& put: '.-...'.
morseTable at: $' put: '.----.'.
morseTable at: $@ put: '.--.-.'.
morseTable at: $) put: '-.--.-'.
morseTable at: $( put: '-.--.'.
morseTable at: $: put: '---...'.
morseTable at: $, put: '--..--'.
morseTable at: $= put: '-...-'.
morseTable at: $! put: '-.-.--'.
morseTable at: $. put: '.-.-.-'.
morseTable at: $- put: '-....-'.
morseTable at: $+ put: '.-.-.'.
morseTable at: $" put: '.-..-.'.
morseTable at: $? put: '..--..'.
morseTable at: $/ put: '-..-.'.
morseTable at: $  put: '/'. "not strictly Morse Code, but helpful"

Smalltalk at: #encodeTable put: morseTable.
Smalltalk at: #decodeTable put: morseTable reverse.


"Main stuff"

Object subclass: MorseEncoder [
    | lastInput currentInput |

    <comment: 'I will convert messages to and
from morse code. One difference from myself from the
rest of the projects is that I will work on the standard
streams, stdin and stdout, instead a generating a direct
result... So, call my functions when you expect something
in the CLI'>

    run [
        "Encode an english message to morse code. The
         incoming message must come in through the stdin
         and the outgoing message (encoded) will go out
         through the stdout.

         Spaces will be reduced to one space only
         and newlines will be kept the same"

        <category: 'main'>
        [stdin atEnd] whileFalse: [
            self acceptInput: stdin next.
            self generateOutput
        ]
    ]

    acceptInput: input [
        "Receive an input"

        <category: 'private'>
        lastInput := currentInput.
        currentInput := input
    ]

    generateOutput [
        "Generate output to stdout

         Rules:
          - Newlines are kept the same
          - Spaces after another spaces are ignored
          - Spaces are represented with $/
          - Inputs with preceding characters in the
            line will produce a preceding space in
            the output"

        <category: 'private'>
        | newline encoded |
        (currentInput = Character nl) ifTrue: [stdout nl. ^self].
        (currentInput = $ ) & (lastInput = $ ) ifTrue: [^self].
        newline := (lastInput isNil) | (lastInput = Character nl). "am I at the beginning of a line?"
        encoded := self encodeCharacter: currentInput.
        newline ifTrue: [stdout nextPutAll: encoded] ifFalse: [stdout nextPutAll: ' ' , encoded]
    ]

    encodeCharacter: character [
        "Convert a character from english to morse code"

        <category: 'private'>
        ^encodeTable
            at: character
            ifAbsent: [self error: 'character ', character, ' not found']
    ]
]

encoder := MorseEncoder new.
encoder run
