#! /usr/bin/gst -f


Object subclass: EssayGenerator [

    <comment: 'I will generate essays based on
texts that have been fed to me. By now, I ignore
all capitalization and ponctuation, making essays
that are essentially one big whole sentece tied
together.'>

    feed: text [
        "Feed me with text. I will use the patterns
         in it when generating new essays"

        <category: 'feeding'>
    ]

    feedFromFile: filename [
        "Feed me the text from filename"

        <category: 'feeding'>
    ]

    generateEssay: numWords [
        "Generate essay with a given number of words"

        <category: 'generating'>
    ]

    generateEssay [
        "Generate a essay with a small number of
         words"

        <category: 'generating'>
    ]
]

eg = EssayGenerator new.
eg feedFromFile: './sample-text.txt'.
(eg generateEssay: 250) displayNl
