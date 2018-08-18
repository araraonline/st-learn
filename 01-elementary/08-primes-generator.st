#! /usr/bin/gst -f


Object subclass: #Math.
Math class extend [
    
    <comment: 'I will help other objects with some Math-related stuff'>

    num: x divisibleby: y [
        "Check if x is divisible by y"

        <category: 'basic operation'>
        ^((x \\ y) = 0)
    ]
].

Stream subclass: PrimeGenerator [
    | primesFound curNum |
    
    <comment: 'I produce an infinite stream of prime numbers.'>
    
    PrimeGenerator class >> new [
        "Override new - we need to initialize the variables in the beginning"

        <category: 'instance creation'>
        ^(super new)
            init;
            yourself
    ]
    
    init [
        "Initialize instance variables"

        <category: 'initialization'>
        primesFound := WriteStream on: (Array new: 10).
        curNum := 2.
    ]

    next [
        "Run through all numbers, returning the next prime"

        <category: 'basic streaming method'>
        [true] whileTrue: [
            (self checkPrime: curNum) ifTrue: [ primesFound nextPut: curNum.  ^curNum ].
            curNum := curNum + 1.
        ]
    ]

    atEnd [
        "The primes never stop"

        <category: 'basic streaming method'>
        ^false
    ]

    checkPrime: num [
        "Check if number is a prime, according to smaller found primes"
        
        <category: 'private method'>
        (primesFound contents) do: [:x | (Math num: num divisibleby: x) ifTrue: [^false] ].
        ^true
    ]
].

primeGenerator := PrimeGenerator new.
primeGenerator do: [:num | num printNl]  "The homework asked to print all prime numbers"
