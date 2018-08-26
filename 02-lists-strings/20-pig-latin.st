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
]


(Piggy new englishToPiglatin: 'The quick brown fox') displayNl.
