#! /usr/bin/gst -f


Object subclass: Machine [
    | secretMin secretMax secret guessedNumbers |
    
    <comment: 'I implement the guessing game. Send #run to start playing.'>

    Machine class >> new [
        "Answer with a new instance of the machine"

        <category: 'instance creation'>
        ^(super new)
            init;
            yourself
    ]

    init [
        "Initialize machine fixed values"

        <category: 'initialization'>
        secretMin := 1.
        secretMax := 10
    ]

    run [
        "Run the guessing game"

        <category: 'outer workings'>
        self chooseSecret.
        guessedNumbers := Set new.
        [true] whileTrue: [
            | guess |
            guess := stdin nextLine asInteger.
            (self makeGuess: guess) ifTrue: [ ^self success ]
        ]
    ]
    
    chooseSecret [
        "Choose the secret number and anounce it"

        <category: 'inner workings'>

        secret := Random between: secretMin and: secretMax.

        'I chose a secret number between ' display.
        secretMin display.
        ' and ' display.
        secretMax display.
        '.' displayNl
    ]

    makeGuess: num [
        "Check if a guess was right"

        <category: 'inner workings'>

        (guessedNumbers includes: num) ifTrue: [
            'You already said this number, try again.' displayNl.
            ^false
        ].

        (num < secret) ifTrue: [
            'This number is smaller than the secret!' displayNl.
            guessedNumbers add: num.
            ^false
        ].

        (num > secret) ifTrue: [
            'This number is bigger than the secret!' displayNl.
            guessedNumbers add: num.
            ^false
        ].

        (num = secret) ifTrue: [
            'Congratulations, this is the secret!' displayNl.
            guessedNumbers add: num.
            ^true
        ]
    ]

    success [
        "Actions when player gets it right"

        <category: 'inner workings'>

        'You won the game (' display.
        guessedNumbers size display.
        ' guesses made).' displayNl.

        [ true ] whileTrue: [
            | answer |
            'Do you want to play again? (y/n)' displayNl.
            answer := stdin nextLine.

            (answer = 'y') ifTrue: [ ^self run ].
            (answer = 'n') ifTrue: [ ^self stop ]
        ]
    ]

    stop [
        "Stop playing with the machine"

        <category: 'inner workings'>
        'Bye, bye.' displayNl
    ]
]

machine := Machine new.
machine run
