#! /usr/bin/gst -f


"Create global variables"
Smalltalk at: #LF put: Character lf.
Smalltalk at: #SPACE put: Character space.


Object subclass: MorseEncoder [
    | morseTable lastInput |

    <comment: 'I will convert messages to and
from morse code. One difference from myself from the
rest of the projects is that I will work on the standard
streams, stdin and stdout, instead a generating a direct
result... So, call my functions when you expect something
in the CLI'>

    MorseEncoder class >> new [
        ^super new initTable
    ]

    initTable [
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
        morseTable at: $/ put: '-..-.'
    ]

    encodeMessage [
        "Encode an english message to morse code. The
         incoming message must come in through the stdin
         and the outgoing message (encoded) will go out
         through the stdout.

         Spaces will be reduced to one space only
         and newlines will be kept the same"

        <category: 'encoding'>
        [stdin atEnd] whileFalse: [
            | input output |
            input := stdin next.
            output := self generateOutput: input.
            stdout nextPutAll: output
        ]
    ]

    generateOutput: input [
        "Generate output for a given output

         Rules:
         - Newlines will be kept the same
         - Spaces that comes right after another will be
           ignored (generate no output)
         - Spaces will be represented as $/
         - All outputs will have a space before them, except
           when in the beginning of a line
        "

        <category: 'private'>
        | newline encoded |
        input = LF ifTrue: [lastInput := LF.  ^LF asString].
        (input = SPACE) & (lastInput = SPACE) ifTrue: [^''].
        newline := (lastInput isNil) | (lastInput = NL). "am I at the beginning of a line?"
        encoded := self encodeCharacter: input.
        lastInput := input.
        newline ifTrue: [^encoded]
                ifFalse: [^' ' , encoded]
    ]

    encodeCharacter: character [
        "Convert a character from english to morse code"

        <category: 'private'>
        character = SPACE ifTrue: [^'/']. "not strict morse code"
        ^morseTable at: character ifAbsent: [self error: 'character ', character, ' not found']
    ]
]

encoder := MorseEncoder new.
encoder encodeMessage
