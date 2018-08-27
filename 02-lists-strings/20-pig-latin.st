#! /usr/bin/gst -f


Object subclass: Piggy [

    <comment: 'I convert messages and words from and to
piggy latin'>

    englishToPiglatin: message [
        "Answer with a pig-latinized version of message.
         I assume no ponctuation is included in it."

        <category: 'message translation'>
        | text addSpace |
        text := ''.
        addSpace := false.
        message substrings do: [:word |
            addSpace ifTrue: [text := text , ' '] ifFalse: [addSpace := true].
            text := text , (self pigifyWord: word)
        ].
        ^text
    ]

    piglatinToEnglish: message [
        "Answer with the original message that originated
         this pig latin message. The opposite of
         englishToPiglatin:"

        <category: 'message translation'>
        | text addSpace |
        text := ''.
        addSpace := false.
        message substrings do: [:word |
            addSpace ifTrue: [text := text , ' '] ifFalse: [addSpace := true].
            text := text , (self unpigifyWord: word)
        ].
        ^text
    ]

    pigifyWord: word [
        "Answer with a pig-latinized version of word"

        <category: 'word translation'>
        | firstLetter uppercase result |
        word size = 0 ifTrue: [^''].
        firstLetter := word at: 1.
        uppercase := firstLetter isUppercase.
        result := ''.
        result := result , (word copyFrom: 2 to: word size).
        result := result , firstLetter asLowercase asString.
        result := result , 'ay'.
        uppercase ifTrue: [result at: 1 put: (result at: 1) asUppercase]. "capitalize if it is needed"
        ^result
    ]

    unpigifyWord: word [
        "Answer with the original of a pig-latinized word"

        <category: 'word translation'>
        | uppercase result |
        uppercase := (word at: 1) isUppercase.
        result := ''.
        result := result , (word at: word size - 2) asString.
        result := result , (word copyFrom: 1 to: word size - 3).
        uppercase ifTrue: [result at: 1 put: (result at: 1) asUppercase.
                           result at: 2 put: (result at: 2) asLowercase].
        ^result
    ]
]


(Piggy new englishToPiglatin: 'The quick brown fox') displayNl.
(Piggy new piglatinToEnglish: 'Hetay uickqay rownbay oxfay') displayNl.
