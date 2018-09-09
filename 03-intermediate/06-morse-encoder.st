#! /usr/bin/gst -f


Dictionary extend [
    reversed [
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
Smalltalk at: #decodeTable put: morseTable reversed.


"Main stuff"

Object subclass: TextTransformer [
    | inputStream outputStream |

    <comment: 'I am a class that abstracts text transformation
from one stream into the next. When I receive the message #run,
I will run through the input stream and process it as needed,
outputing results to outputStream.

Please note that I''m an abstract class. My subclasses must implement
a method for #processInput: and shall also implement the #startRun
and #finishRun methods.'>

    setInputStream: aStream [
        "Set the input stream"

        <category: 'initialization'>
        inputStream := aStream
    ]

    setOutputStream: aStream [
        "Set the output stream"

        <category: 'initialization'>
        outputStream := aStream
    ]

    run [
        "Take inputs from inputStream and process them"

        <category: 'running'>
        self startRun.
        inputStream do: [:input | self processInput: input].
        self finishRun
    ]

    startRun [
        "Message received just before the run.
         Use it to prepare for the process.

         By default, this is empty."

        <category: 'running steps'>
    ]

    processInput: input [
        "Message received for each input in inputStream.
         use it to process the input in whatever manner
         you wish"

        <category: 'running steps'>
        self subclassResponsibility
    ]

    finishRun [
        "Message received just after the run.
         Use it to clean the process or
         output leftovers.

         By default, this is empty."

        <category: 'running steps'>
    ]
]


TextTransformer subclass: MorseEncoder [
    | lastInput currentInput |

    processInput: input [
        "Process one input character"

        <category: 'transformation steps'>
        self acceptInput: input.
        self generateOutput
    ]

    acceptInput: input [
        "Receive an input"

        <category: 'private'>
        lastInput := currentInput.
        currentInput := input
    ]

    generateOutput [
        "Generate output

         Rules:
          - Newlines are kept the same
          - Spaces after another spaces are ignored
          - Spaces are represented with $/
          - Inputs with preceding characters in the
            line will produce a preceding space in
            the output"

        <category: 'private'>
        | newline encoded |
        (currentInput = Character nl) ifTrue: [outputStream nl. ^self].
        (currentInput = $ ) & (lastInput = $ ) ifTrue: [^self].
        newline := (lastInput isNil) | (lastInput = Character nl). "am I at the beginning of a line?"
        encoded := self encodeCharacter: currentInput.
        newline ifTrue: [outputStream nextPutAll: encoded] ifFalse: [outputStream nextPutAll: ' ' , encoded]
    ]

    encodeCharacter: character [
        "Convert a character from english to morse code"

        <category: 'private'>
        ^encodeTable
            at: character
            ifAbsent: [self error: 'character ', character, ' not found']
    ]
]

TextTransformer subclass: MorseDecoder [
    | buffer |

    <comment: 'I will decode morse code streams'>

    startRun [
        buffer := WriteStream on: String new
    ]

    processInput: input [
        (input = Character nl) ifTrue: [self emptyBufferToStream. ^outputStream nl].
        (input = $ ) ifTrue: [^self emptyBufferToStream].
        buffer nextPut: input
    ]

    finishRun [
        self emptyBufferToStream
    ]

    emptyBufferToStream [
        | decoded |
        (buffer size = 0) ifTrue: [^self]. "buffer is empty, nothing to do"
        decoded := self decodeCharacter: buffer contents.
        outputStream nextPut: decoded.
        buffer emptyStream
    ]

    decodeCharacter: morseCharacter [
        ^decodeTable
            at: morseCharacter
            ifAbsent: [self error: 'could not decode ' , morseCharacter]
    ]
]

encoder := MorseEncoder new.
encoder setInputStream: stdin.
encoder setOutputStream: stdout.
encoder run
