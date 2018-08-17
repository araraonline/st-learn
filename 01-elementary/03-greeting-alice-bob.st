#! /usr/bin/gst -f

'What is your name, bro?' displayNl.
userName := stdin nextLine.

((userName = 'Alice') | (userName = 'Bob'))
    ifTrue: [
        'Hey there, ' display.
        userName display.
        '!' displayNl
    ]
    ifFalse: [ 'Hey there!' displayNl ]
