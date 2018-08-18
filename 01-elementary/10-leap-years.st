#! /usr/bin/gst -f


Object subclass: Math [

    <comment: 'I will help other objects with some Math-related stuff'>

    Math class >> num: x divisibleby: y [
        "Check if x is divisible by y"

        <category: 'basic'>
        ^((x \\ y) = 0)
    ]

]

Object subclass: LeapHelper [

    <comment: 'I just help with the leap year calculation. Check #checkLeap.'>

    LeapHelper class >> checkLeapYear: year [
        "Check if year is a leap year or not"

        <category: 'basic'>
        (Math num: year divisibleby: 4) ifFalse: [^false].
        (Math num: year divisibleby: 100) ifFalse: [^true].
        (Math num: year divisibleby: 400) ifFalse: [^false].
        ^true
    ]

    LeapHelper class >> test [
        "Test if the calculations are running right"

        <category: 'testing'>
        | leapYears notLeapYears |
        leapYears := Set new add: 400; add: 800; add: 404; add: 828; yourself.
        notLeapYears := Set new add: 100; add: 300; add: 403; add: 826; yourself.
        leapYears do: [:y| (self checkLeapYear: y) ifFalse: [self error: 'Bad leap year']]    .
        notLeapYears do: [:y| (self checkLeapYear: y) ifTrue: [self error: 'Bad non-leap year']]    .
    ]
]

Stream subclass: LeapYearGenerator [
    | curYear |


    LeapYearGenerator class >> new [
        "Start generating year from year 1"

        <category: 'instance creation'>
        ^(self from: 1)
    ]

    LeapYearGenerator class >> from: year [
        "Start generating leap years from given year"

        <category: 'instance creation'>
        ^(super new)
            setYear: year;
            yourself
    ]

    setYear: year [
        curYear := year - 1  "the year is added one when calling #next"
    ]

    next [
        [ true ] whileTrue: [
            curYear := curYear + 1.
            (LeapHelper checkLeapYear: curYear) ifTrue: [^curYear]
        ]
    ]

    atEnd [
        ^false
    ]
]


"prepare"

startYear := Date dateAndTimeNow year + 1.
generator := LeapYearGenerator from: startYear.


"display"

'The next 20 leap years:' displayNl.
'' displayNl.
(generator next: 20) do: [:y | y displayNl]
