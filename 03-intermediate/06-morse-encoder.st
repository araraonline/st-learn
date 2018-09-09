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

String class extend [
    lf [
        "Returns a string containing a single lf character"

        <category: 'constants'>
        ^Character lf asString
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

Smalltalk at: #encodeTable put: morseTable.
Smalltalk at: #decodeTable put: morseTable reversed.
decodeTable at: '/' put: $ . "isolated slashes (e.g. ' / ')
                              will be considered a word separator
                              (space) in the incoming code"


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

    transform: aString [
        "Set up custom streams to directly get the result of
         transforming aString with this transformer"

        <category: 'running'>
        | in out |
        in := ReadStream on: aString.
        out := WriteStream on: String new.
        self setInputStream: in.
        self setOutputStream: out.
        self run.
        ^out contents
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
    | beginningOfLine waitingForWord |

    <comment: 'I will encode text streams into
Morse code'>

    startRun [
        "Initialize run vars"

        <category: 'transformation steps'>
        beginningOfLine := true.
        waitingForWord := false "use this when you should add a space before the word"
    ]

    processInput: input [
        "Process one input character

         Rules:
          - Newlines are kept the same
          - Leading/Trailing/Spare spaces are ignored
          - Letters are separated by ' '
          - Words are separated by ' / ' or a LF"

        <category: 'transformation steps'>
        (input = Character lf) ifTrue: [^self lf].
        (input = $ ) ifTrue: [^self space].
        ^self character: input
    ]

    lf [
        "Add a new line to the output"

        <category: 'private'>
        outputStream nl.
        beginningOfLine := true.
    ]

    space [
        "Add a space to the output"

        <category: 'private'>
        waitingForWord := true
    ]

    character: aCharacter [
        "Encode and add aCharacter to the output"

        <category: 'private'>
        | encoded |
        beginningOfLine ifFalse: [waitingForWord ifTrue: [outputStream nextPutAll: ' / ']  "new word"
                                                 ifFalse: [outputStream nextPutAll: ' ']]. "new letter of word"
        encoded := self encodeCharacter: aCharacter.
        outputStream nextPutAll: encoded.
        beginningOfLine := false.
        waitingForWord := false
    ]

    encodeCharacter: character [
        "Convert a character from english to morse code"

        <category: 'private'>
        ^encodeTable
            at: character asLowercase
            ifAbsent: [self error: 'character ', character, ' not found']
    ]
]

TextTransformer subclass: MorseDecoder [
    | buffer |

    <comment: 'I will decode morse code streams'>

    startRun [
        "Initialize buffer"

        <category: 'transformation steps'>
        buffer := WriteStream on: String new
    ]

    processInput: input [
        "Process one input character

        Decoding rules:
         - New lines are kept the same
         - Encoded spaces are kept the same
         - Spaces in the input string represent letter separators
         - Leading/Trailing/Spare spaces in the input string are ignored
         - Decoded text will be in lowercase"

        <category: 'transformation steps'>
        (input = Character nl) ifTrue: [self emptyBufferToStream. ^outputStream nl].
        (input = $ ) ifTrue: [^self emptyBufferToStream].
        buffer nextPut: input
    ]

    finishRun [
        "Clear buffer"

        <category: 'transformation steps'>
        self emptyBufferToStream
    ]

    emptyBufferToStream [
        "Empty buffer and pour its contents on outputStream"

        <category: 'private'>
        | decoded |
        (buffer size = 0) ifTrue: [^self]. "buffer is empty, nothing to do"
        decoded := self decodeCharacter: buffer contents.
        outputStream nextPut: decoded.
        buffer emptyStream
    ]

    decodeCharacter: morseCharacter [
        "Decode morseCharacter (a String object) into its
         corresponding character"

        <category: 'private'>
        ^decodeTable
            at: morseCharacter
            ifAbsent: [self error: 'could not decode ' , morseCharacter]
    ]
]


"Tests"

Object subclass: Tester [
    run [
        "Test the MorseEncoder and MorseDecoder classes"

        self testEncoder.
        self testDecoder
    ]

    testEncoder [
        | encoder testInput testOutput |
        encoder := MorseEncoder new.
        (encoder transform: 'a') = '.-'
            ifFalse: [self error: 'a'].
        (encoder transform: 'A') = '.-'
            ifFalse: [self error: 'A'].
        (encoder transform: ' a') = '.-'
            ifFalse: [self error: '+a'].
        (encoder transform: '  a') = '.-'
            ifFalse: [self error: '++a'].
        (encoder transform: 'a ') = '.-'
            ifFalse: [self error: 'a+'].
        (encoder transform: 'a  ') = '.-'
            ifFalse: [self error: 'a++'].
        (encoder transform: 'aa') = '.- .-'
            ifFalse: [self error: 'aa'].
        (encoder transform: 'a a') = '.- / .-'
            ifFalse: [self error: 'a+a'].
        (encoder transform: 'a  a') = '.- / .-'
            ifFalse: [self error: 'a++a'].
        (encoder transform: 'a   a') = '.- / .-'
            ifFalse: [self error: 'a+++a'].
        (encoder transform: 'a a') = '.- / .-'
            ifFalse: [self error: 'a+a'].
        (encoder transform: 'a' , String lf) = ('.-' , String lf)
            ifFalse: [self error: 'a-'].
        (encoder transform: 'a' , String lf, 'a') = ('.-' , String lf, '.-')
            ifFalse: [self error: 'a-a'].
        (encoder transform: 'a' , String lf, ' a') = ('.-' , String lf, '.-')
            ifFalse: [self error: 'a-+a'].

        testInput := 'A quick brown fox jumps over the lazy dog'.
        testOutput := '.- / --.- ..- .. -.-. -.- / -... .-. --- .-- -. / ..-. --- -..- / .--- ..- -- .--. ... / --- ...- . .-. / - .... . / .-.. .- --.. -.-- / -.. --- --.'.
        (encoder transform: testInput) = testOutput
            ifFalse: [self error: testInput].

        testInput := '0123456789&''@)(:,=!.-+"?/'.
        testOutput := '----- .---- ..--- ...-- ....- ..... -.... --... ---.. ----. .-... .----. .--.-. -.--.- -.--. ---... --..-- -...- -.-.-- .-.-.- -....- .-.-. .-..-. ..--.. -..-.'.
        (encoder transform: testInput) = testOutput
            ifFalse: [self error: testInput].

        'Encoder tests okay!' displayNl
    ]

    testDecoder [
        | decoder testInput testOutput |
        decoder := MorseDecoder new.
        (decoder transform: '.-') = 'a'
            ifFalse: [self error: '.-'].
        (decoder transform: ' .-') = 'a'
            ifFalse: [self error: '+.-'].
        (decoder transform: '.- ') = 'a'
            ifFalse: [self error: '.-+'].
        (decoder transform: '  .-') = 'a'
            ifFalse: [self error: '++.-'].
        (decoder transform: '.-  ') = 'a'
            ifFalse: [self error: '.-++'].
        (decoder transform: '.- .-') = 'aa'
            ifFalse: [self error: '.-+.-'].
        (decoder transform: '.-  .-') = 'aa'
            ifFalse: [self error: '.-++.-'].
        (decoder transform: '.- / .-') = 'a a'
            ifFalse: [self error: '.-+/+.-'].
        (decoder transform: '.- / / .-') = 'a  a'
            ifFalse: [self error: '.-+/+/+.-'].
        (decoder transform: '.-  /  .-') = 'a a'
            ifFalse: [self error: '.-++/++.-'].
        (decoder transform: '/ .-') = ' a'
            ifFalse: [self error: '/+.-'].
        (decoder transform: ' / .-') = ' a'
            ifFalse: [self error: '+/+.-'].
        (decoder transform: '  / .-') = ' a'
            ifFalse: [self error: '++/+.-'].
        (decoder transform: '.- /') = 'a '
            ifFalse: [self error: '.-+/'].
        (decoder transform: '.- /  ') = 'a '
            ifFalse: [self error: '.-+/++'].
        (decoder transform: '.-' , String lf) = ('a' , String lf)
            ifFalse: [self error: '.-L'].
        (decoder transform: '.-' , String lf, '.-') = ('a' , String lf, 'a')
            ifFalse: [self error: '.-L.-'].
        (decoder transform: ' .-' , String lf, '.-') = ('a' , String lf, 'a')
            ifFalse: [self error: '+.-L.-'].
        (decoder transform: '.-' , String lf, ' .-') = ('a' , String lf, 'a')
            ifFalse: [self error: '.-L+.-'].
        (decoder transform: ' .- ' , String lf, ' .- ') = ('a' , String lf, 'a')
            ifFalse: [self error: '+.-+L+.-+'].
        (decoder transform: '.-' , String lf, '/ .-') = ('a' , String lf, ' a')
            ifFalse: [self error: '.-L/+.-'].
        (decoder transform: '.-' , String lf, '/ / .-') = ('a' , String lf, '  a')
            ifFalse: [self error: '.-L/+/+.-'].
        (decoder transform: '.-' , String lf, '  / / .-') = ('a' , String lf, '  a')
            ifFalse: [self error: '.-L++/+/+.-'].

        testInput := '.- / --.- ..- .. -.-. -.- / -... .-. --- .-- -. / ..-. --- -..- / .--- ..- -- .--. ... / --- ...- . .-. / - .... . / .-.. .- --.. -.-- / -.. --- --.'.
        testOutput := 'a quick brown fox jumps over the lazy dog'.
        (decoder transform: testInput) = testOutput
            ifFalse: [self error: testInput].

        testInput := '----- .---- ..--- ...-- ....- ..... -.... --... ---.. ----. .-... .----. .--.-. -.--.- -.--. ---... --..-- -...- -.-.-- .-.-.- -....- .-.-. .-..-. ..--.. -..-.'.
        testOutput := '0123456789&''@)(:,=!.-+"?/'.
        (decoder transform: testInput) = testOutput
            ifFalse: [self error: testInput].

        'Decoder tests okay!' displayNl
    ]
]

Tester new run


"Example usage (in this file):

>> encoder := MorseEncoder new.
>> encoder setInputStream: stdin.
>> encoder setOutputStream: stdout.
>> encoder run


Then the script can be run like this (in the terminal):

>> echo 'I want to encode this!' | ./06-morse-encoder.st
.. / .-- .- -. - / - --- / . -. -.-. --- -.. . / - .... .. ... -.-.--

"
