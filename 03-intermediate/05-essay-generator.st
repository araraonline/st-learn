#! /usr/bin/gst -f


Array extend [
    randomElement [
        "Answer with a random element of myself"

        <category: 'random'>
        self size = 0 ifTrue: [self error: 'list is empty'].
        ^self at: (Random between: 1 and: self size)
    ]
]

Set extend [
    randomElement [
        "Answer with a random element of myself"

        <category: 'random'>
        self size = 0 ifTrue: [self error: 'set is empty'].
        ^self asArray randomElement
    ]
]


Bag extend [
    randomElement [
        "Answer with a random element of myself"

        <category: 'random'>
        self size = 0 ifTrue: [self error: 'bag is empty'].
        ^self asArray randomElement
    ]
]


Object subclass: EssayGenerator [
    | successors |

    <comment: 'I will generate essays based on
texts that have been fed to me. By now, I ignore
all formating, making essays that are essentially
one big paragraph of sentences together.'>

    EssayGenerator class >> new [
        "Answer with a new isntance of EssayGenerator"

        <category: 'instance creation'>
        ^super new init
    ]

    init [
        "Initialize myself"

        <category: 'private'>
        successors := LookupTable new
    ]

    feed: text [
        "Feed me with text. I will use the patterns
         in it when generating new essays"

        <category: 'feeding'>
        | words |
        words := text tokenize: '[\s\n]+'.
        1 to: words size - 1 do: [:i |
            | word1 word2 bag |
            word1 := words at: i.
            word2 := words at: i + 1.
            bag := successors at: word1 ifAbsent: [Bag new].
            bag add: word2.
            successors at: word1 put: bag
        ]
    ]

    feedFromFile: filename [
        "Feed me the text from filename"

        <category: 'feeding'>
        | stream |
        stream := FileStream open: filename mode: FileStream read.
        ^self feed: stream upToEnd
    ]

    generateEssay: numWords [
        "Generate essay with a given number of words"

        <category: 'generating'>
        | words curWord |
        numWords < 0 ifTrue: [self error: 'numWords must be a positive integer'].
        words := WriteStream on: Array new.
        numWords timesRepeat: [
            curWord := self chooseSuccessor: curWord.
            words nextPut: curWord
        ].
        ^words contents join: ' '
    ]

    generateEssay [
        "Generate an essay with 500 words"

        <category: 'generating'>
        ^self generateEssay: 500
    ]

    chooseSuccessor: word [
        "Choose a random successor of word, as seen in the
         texts. If word is nil, choose a completely random
         one"

        <category: 'private'>
        word isNil ifTrue: [^successors keys randomElement].
        ^(successors at: word) randomElement
    ]
]

eg := EssayGenerator new.
eg feedFromFile: './sample-text.txt'.
eg generateEssay displayNl
