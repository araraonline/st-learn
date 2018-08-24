#! /usr/bin/gst -f


Magnitude subclass: SlowInteger [
    | minus digits radix digitCalculator digitExtractor |

    <comment: 'I''m a custom class of integers, created as an exercise.
My instances only make two assumptions, numbers are made out of digits,
and, digits can be summed, subtracted and multiplied in an outer component.
Based on this, I implement +, - and * operations for whole numbers! Of
course, I will be pretty slow, so, that''s why I''m called SlowInteger.'>

    SlowInteger class >> from: number usingRadix: radix [
        "Answer with a SlowInteger working on radix"

        <category: 'intance creation'>
        ^super new
            setNumber: number andRadix: radix;
            yourself
    ]

    SlowInteger class >> fromDigits: digits minus: minus radix: radix [
        "Answer with a new SlowInteger instance based on internals"

        <category: 'instance creation'>
        ^super new
            setMinus: minus;
            setDigits: digits;  "order is important"
            setRadix: radix;
            yourself
    ]

    SlowInteger class >> fromDigit: digit minus: minus radix: radix [
        "Answer with a new SlowInteger based on internals"

        <category: 'instance creation'>
        ^SlowInteger
            fromDigits: digit asString
            minus: minus
            radix: radix
    ]

    setNumber: number andRadix: integerBase [
        "Set myself to a given number on a given base"

        <category: 'private'>
        self setRadix: integerBase.
        self setMinus: number < 0.
        self setDigits: (digitExtractor extractDigitsFrom: number)
    ]

    setMinus: minusValue [
        "Set internal sign"

        <category: 'private'>
        minus := minusValue.
    ]

    setDigits: digitsValue [
        "Set internal digits, filtering them"

        <category: 'private'>
        digits := digitsValue
            replacingRegex: (Regex fromString: '^(0+)')
            with: ''.
        self isZero ifTrue: [minus := false].
    ]

    setRadix: integerBase [
        "Set internal radix and initialize related"

        <category: 'private'>
        radix := integerBase.
        digitCalculator := DigitCalculator usingRadix: radix.
        digitExtractor := DigitExtractor usingRadix: radix
    ]

    isZero [
        "Check if I'm the number zero"

        <category: 'math - tests'>
        ^self digitCount = 0
    ]

    isPositive [
        "Check if I'm greater than 0"

        <category: 'math - tests'>
        ^self isZero not & (minus = false)
    ]

    isNegative [
        "Check if I'm lower than 0"

        <category: 'math - tests'>
        ^self isZero not & (minus = true)
    ]

    zero [
        "Answer with zero at the current radix"

        <category: 'math - constants'>
        ^SlowInteger
            fromDigit: $0
            minus: false
            radix: radix
    ]

    one [
        "Answer with one at the current radix"

        <category: 'math - constants'>
        ^SlowInteger
            fromDigit: $1
            minus: false
            radix: radix
    ]

    negated [
        "Create a new copy of myself, with the sign inverted"

        <category: 'math - misc'>
        ^SlowInteger
            fromDigits: digits
            minus: minus not
            radix: radix
    ]

    at: position [
        "Return the digit at position. Counts from right to left"

        <category: 'math - misc'>
        position <= 0 ifTrue: [ self error: 'position must be 1 or higher' ].
        position <= self digitCount
            ifTrue: [ ^digits at: digits size - position + 1 ]
            ifFalse: [ ^$0 ]
    ]

    digitCount [
        "Return the digit count of the receiver"

        <category: 'math - misc'>
        ^digits size
    ]

    + anotherInteger [
        "Answer with the sum of myself and anotherInteger"

        <category: 'operation'>
        | num1 num2 results sum carry |
        num1 := self.
        num2 := anotherInteger.
        results := WriteStream on: String new.

        (num1 isNegative & num2 isPositive)
            ifTrue: [^num2 - num1 negated].
        (num1 isPositive & num2 isNegative)
            ifTrue: [^num1 - num2 negated].
        (num1 isNegative & num2 isNegative)
            ifTrue: [^(num1 negated + num2 negated) negated].

        carry := $0.
        1 to: (num1 digitCount max: num2 digitCount) do: [:pos |
            sum := digitCalculator sum: (num1 at: pos) with: (num2 at: pos).
            (carry = $1) ifTrue: [sum := sum + self one].
            results nextPut: (sum at: 1).
            carry := (sum at: 2)
        ].
        (carry = $1) ifTrue: [results nextPut: $1].
        ^SlowInteger
            fromDigits: results reverseContents
            minus: false
            radix: radix
    ]

    - anotherInteger [
        "Answer with the subtraction of myself and anotherInteger"

        <category: 'operation'>
        | num1 num2 results sub carry |
        num1 := self.
        num2 := anotherInteger.
        results := WriteStream on: String new.

        num1 isZero ifTrue: [^num2 negated].
        num2 isZero ifTrue: [^num1].
        (num1 isPositive & num2 isPositive & (num1 < num2))
            ifTrue: [^(num2 - num1) negated].
        (num1 isPositive & num2 isNegative)
            ifTrue: [^num1 + num2 negated].
        (num1 isNegative & num2 isPositive)
            ifTrue: [^num1 + num2 negated].
        (num1 isNegative & num2 isNegative)
            ifTrue: [^num2 negated - num1 negated].

        carry := $0.
        1 to: (num1 digitCount max: num2 digitCount) do: [:pos |
            sub := digitCalculator subtract: (num2 at: pos) from: (num1 at: pos).
            (carry = $1) ifTrue: [sub := sub - self one].
            sub isNegative
                ifTrue: [carry := $1.
                         results nextPut: ((digitCalculator subtractFrom10: (sub at: 1)) at: 1)]
                ifFalse: [carry := $0.
                          results nextPut: (sub at: 1)].
        ].

        ^SlowInteger
            fromDigits: results reverseContents
            minus: false
            radix: radix
    ]

    * anotherInteger [
        "Answer with the multiplication of myself and anotherInteger"

        <category: 'operation'>
        | num1 num2 results digit mul |
        num1 := self.
        num2 := anotherInteger.
        results := self zero.

        (num1 isPositive & num2 isNegative)
            ifTrue: [^(num1 * num2 negated) negated].
        (num1 isNegative & num2 isPositive)
            ifTrue: [^(num1 negated * num2) negated].
        (num1 isNegative & num2 isNegative)
            ifTrue: [^num1 negated * num2 negated].

        1 to: num2 digitCount do: [:pos |
            digit := num2 at: pos.
            mul := self multiplySimpleBy: digit.
            results := results + (mul shifted: pos - 1)
        ].

        ^results
    ]

    multiplySimpleBy: digit [
        "Answer with the multiplication of myself and digit"

        <category: 'private'>
        | results mul |
        results := self zero.
        1 to: self digitCount do: [:pos |
            mul := digitCalculator multiply: (self at: pos) with: digit.
            results := results + (mul shifted: pos - 1)
        ].
        ^results
    ]

    shifted: k [
        "Answer with myself shifted k units to the left (* radix to the k)"

        <category: 'private'>
        | newDigits |
        newDigits := String new: self digitCount + k.
        (WriteStream on: newDigits)
            nextPutAll: digits;
            next: k put: $0.
        ^SlowInteger
            fromDigits: newDigits
            minus: minus
            radix: radix
    ]

    printOn: aStream [
        "Print myself on a stream"

        <category: 'printing'>
        radix displayOn: aStream.
        'r' displayOn: aStream.
        self isZero
            ifTrue: ['0' displayOn: aStream]
            ifFalse: [minus ifTrue: ['-' displayOn: aStream].
                      digits displayOn: aStream]
    ]

    = anotherInteger [
        "Compare myself with another number"

        <category: 'comparison'>
        | num1 num2 |
        num1 := self.
        num2 := anotherInteger.

        num1 digitCount = num2 digitCount ifFalse: [^false].
        num1 isPositive = num2 isPositive ifFalse: [^false].
        1 to: num1 digitCount do: [:pos | (num1 at: pos) = (num2 at: pos) ifFalse: [^false]].
        ^true
    ]

    < anotherInteger [
        "Check if I''m smaller than anotherInteger"

        <category: 'comparison'>
        | num1 num2 |
        num1 := self.
        num2 := anotherInteger.

        num1 isNegative ifTrue: [
            num2 isZero ifTrue: [^true].
            num2 isPositive ifTrue: [^true].
            ^num1 negated > num2 negated
        ].
        num1 isZero ifTrue: [
            num2 isNegative ifTrue: [^false].
            num2 isPositive ifTrue: [^true].
            ^false
        ].
        num1 isPositive ifTrue: [
            num2 isNegative ifTrue: [^false].
            num2 isZero ifTrue: [^false].
            num1 digitCount < num2 digitCount ifTrue: [^true].
            num1 digitCount > num2 digitCount ifTrue: [^false].
            num1 digitCount to: 1 by: -1 do: [:pos |
                (num1 at: pos) < (num2 at: pos) ifTrue: [^true].
                (num1 at: pos) > (num2 at: pos) ifTrue: [^false].
            ].
            ^false "they are the same"
        ]
    ]

    asInteger [
        "Convert myself to integer. Do NOT use this during calculations
         as it would be cheating."

        <category: 'conversion'>
        | stream result |
        stream := ReadStream on: digits.
        result := Integer readFrom: stream radix: radix.
        self isNegative
            ifTrue: [^result negated]
            ifFalse: [^result]
    ]
]

Object subclass: DigitCalculator [
    | radix |

    <comment: 'I operate on SlowInteger digits returning results to
operations. Assumptions of the system capabilities are made through
my messages.'>

    DigitCalculator class >> usingRadix: radix [
        "Create a new DigitCalculator"

        <category: 'instance creation'>
        ^super new
            setRadix: radix
    ]

    setRadix: integerBase [
        "Set the radix I will operate on"

        <category: 'private'>
        radix := integerBase
    ]

    sum: digit1 with: digit2 [
        "Return the result of digit1 + digit2"

        <category: 'operation'>
        | num1 num2 |
        num1 := self toInteger: digit1.
        num2 := self toInteger: digit2.
        ^SlowInteger from: (num1 + num2) usingRadix: radix
    ]

    subtract: digit2 from: digit1 [
        "Return the result of digit1 - digit2"

        <category: 'operation'>
        | num1 num2 |
        num1 := self toInteger: digit1.
        num2 := self toInteger: digit2.
        ^SlowInteger from: (num1 - num2) usingRadix: radix
    ]

    multiply: digit1 with: digit2 [
        "Return the result of digit1 * digit2"

        <category: 'operation'>
        | num1 num2 |
        num1 := self toInteger: digit1.
        num2 := self toInteger: digit2.
        ^SlowInteger from: (num1 * num2) usingRadix: radix
    ]

    subtractFrom10: digit [
        "Return the result of 10 - digit (10 here is in the
         specified base)"

        <category: 'operation'>
        | num1 num2 |
        num1 := radix.
        num2 := self toInteger: digit.
        ^SlowInteger from: (num1 - num2) usingRadix: radix
    ]

    toInteger: digit [
        "Convert digit to an integer"

        <catgory: 'private'>
        | stream |
        stream := Generator on: [:gen | gen yield: digit].
        ^Integer readFrom: stream radix: radix
    ]
]

Object subclass: DigitExtractor [
    | radix |

    <comment: 'I extract the digits from numbers in the radix
you specify'>

    DigitExtractor class >> usingRadix: radix [
        "Create a new DigitExtractor"

        <category: 'instance creation'>
        ^super new
            setRadix: radix
    ]

    setRadix: integerBase [
        "Set the radix I will operate on"

        <category: 'private'>
        radix := integerBase
    ]

    extractDigitsFrom: number [
        "Extract an array of digits from number"

        <category: 'basic'>
        | num string |
        num := number.
        num := num < 0 ifTrue: [num negated] ifFalse: [num].
        ^num printString: radix
    ]
]

Object subclass: Tester [
    Tester class >> all [
        self testDigitExtractor.
        self testDigitCalculator.
        self testSlowInteger.
        'All tests ok!' displayNl
    ]

    Tester class >> testDigitExtractor [
        | digitExtractor |
        digitExtractor := DigitExtractor usingRadix: 2.
        (digitExtractor extractDigitsFrom: 10) = '1010'
            ifFalse: [self error: 'couldn''t extract 10 digits on base 2'].
        (digitExtractor extractDigitsFrom: 999) = '1111100111'
            ifFalse: [self error: 'couldn''t extract 999 digits on base 2'].
        (digitExtractor extractDigitsFrom: -999) = '1111100111'
            ifFalse: [self error: 'couldn''t extract -999 digits on base 2'].

        digitExtractor := DigitExtractor usingRadix: 10.
        (digitExtractor extractDigitsFrom: 10) = '10'
            ifFalse: [self error: 'couldn''t extract 10 digits on base 10'].
        (digitExtractor extractDigitsFrom: 999) = '999'
            ifFalse: [self error: 'couldn''t extract 999 digits on base 10'].
        (digitExtractor extractDigitsFrom: -999) = '999'
            ifFalse: [self error: 'couldn''t extract -999 digits on base 10'].

        digitExtractor := DigitExtractor usingRadix: 16.
        (digitExtractor extractDigitsFrom: 16) = '10'
            ifFalse: [self error: 'couldn''t extract 16 digits on base 16'].
        (digitExtractor extractDigitsFrom: 999) = '3E7'
            ifFalse: [self error: 'couldn''t extract 999 digits on base 16'].
        (digitExtractor extractDigitsFrom: -999) = '3E7'
            ifFalse: [self error: 'couldn''t extract -999 digits on base 16'].
    ]

    Tester class >> testDigitCalculator [
        | digitCalculator |
        digitCalculator := DigitCalculator usingRadix: 10.
        (digitCalculator sum: $1 with: $1) = (SlowInteger from: 2 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 1 + 1 on base 10'].
        (digitCalculator sum: $9 with: $5) = (SlowInteger from: 14 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 9 + 5 on base 10'].
        (digitCalculator subtract: $1 from: $1) = (SlowInteger from: 0 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 1 - 1 on base 10'].
        (digitCalculator subtract: $5 from: $9) = (SlowInteger from: 4 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 9 - 5 on base 10'].
        (digitCalculator multiply: $1 with: $1) = (SlowInteger from: 1 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 1 * 1 on base 10'].
        (digitCalculator multiply: $9 with: $5) = (SlowInteger from: 45 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 9 * 5 on base 10'].
        (digitCalculator subtractFrom10: $0) = (SlowInteger from: 10 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 10 - 0 on base 10'].
        (digitCalculator subtractFrom10: $4) = (SlowInteger from: 6 usingRadix: 10)
            ifFalse: [self error: 'couldn''t compute 10 - 4 on base 10'].

        digitCalculator := DigitCalculator usingRadix: 16.
        (digitCalculator sum: $1 with: $1) = (SlowInteger from: 2 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 1 + 1 on base 16'].
        (digitCalculator sum: $A with: $B) = (SlowInteger from: 21 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute A + B on base 16'].
        (digitCalculator sum: $9 with: $5) = (SlowInteger from: 14 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 9 + 5 on base 16'].
        (digitCalculator subtract: $1 from: $1) = (SlowInteger from: 0 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 1 - 1 on base 16'].
        (digitCalculator subtract: $5 from: $9) = (SlowInteger from: 4 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 9 - 5 on base 16'].
        (digitCalculator multiply: $1 with: $1) = (SlowInteger from: 1 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 1 * 1 on base 16'].
        (digitCalculator multiply: $9 with: $5) = (SlowInteger from: 45 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 9 * 5 on base 16'].
        (digitCalculator subtractFrom10: $0) = (SlowInteger from: 16 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 10 - 0 on base 16'].
        (digitCalculator subtractFrom10: $4) = (SlowInteger from: 12 usingRadix: 16)
            ifFalse: [self error: 'couldn''t compute 10 - 4 on base 16'].
    ]

    Tester class >> testSlowInteger [
        | zero one mOne zOne two five nine ten twotwotwo twotwotwosq zeroPos zeroNeg |
        zero := SlowInteger from: 0 usingRadix: 10.
        one := SlowInteger from: 1 usingRadix: 10.
        zOne := SlowInteger fromDigits: '01' minus: false radix: 10.
        mOne := SlowInteger from: -1 usingRadix: 10.
        two := SlowInteger from: 2 usingRadix: 10.
        five := SlowInteger from: 5 usingRadix: 10.
        nine := SlowInteger from: 9 usingRadix: 10.
        ten := SlowInteger from: 10 usingRadix: 10.
        twotwotwo := SlowInteger from: 222 usingRadix: 10.
        twotwotwosq := SlowInteger from: 49284 usingRadix: 10.
        zeroPos := SlowInteger fromDigit: $0 minus: false radix: 10.
        zeroNeg := SlowInteger fromDigit: $0 minus: true radix: 10.

        zeroPos = zeroNeg
            ifFalse: [self error: '0 is different from -0 on base 10'].
        zero = zero
            ifFalse: [self error: '0 is different from 0 on base 10'].
        one = one
            ifFalse: [self error: '1 is different from 1 on base 10'].
        mOne = mOne
                ifFalse: [self error: '-1 is different from -1 on base 10'].
        one = zOne
            ifFalse: [self error: '1 is different from 01 on base 10'].
        twotwotwo = twotwotwo
            ifFalse: [self error: '222 is different from 222 on base 10'].

        zero asInteger = 0
            ifFalse: [self error: 'could not convert 0 back to integer'].
        one asInteger = 1
            ifFalse: [self error: 'could not convert 1 back to integer'].
        mOne asInteger = -1
            ifFalse: [self error: 'could not convert -1 back to integer'].
        twotwotwo asInteger = 222
            ifFalse: [self error: 'could not convert 222 back to integer'].

        zero ~= one
            ifFalse: [self error: '0 is equal to 1 on base 10'].
        one ~= ten
            ifFalse: [self error: '1 is equal to 10 on base 10'].
        one ~= mOne
            ifFalse: [self error: '1 is equal to -1 on base 10'].

        one = mOne negated
            ifFalse: [self error: '1 is different from -(-1) on base 10'].
        one negated = mOne
            ifFalse: [self error: '-(1) is different from -1 on base 10'].

        zero < one
            ifFalse: [self error: '0 not less than 1'].
        one < twotwotwo
            ifFalse: [self error: '1 not less than 222'].
        mOne < one
            ifFalse: [self error: '-1 not less than 1'].

        zero isZero
            ifFalse: [self error: '0 is not zero'].
        zeroPos isZero
            ifFalse: [self error: '+0 is not zero'].
        zeroNeg isZero
            ifFalse: [self error: '-0 is not zero'].
        zero isNegative not
            ifFalse: [self error: '0 is negative'].
        zeroPos isNegative not
            ifFalse: [self error: '+0 is negative'].
        zeroNeg isNegative not
            ifFalse: [self error: '-0 is negative'].
        zero isPositive not
            ifFalse: [self error: '0 is positive'].
        zeroPos isPositive not
            ifFalse: [self error: '+0 is positive'].
        zeroNeg isPositive not
            ifFalse: [self error: '-0 is positive'].

        one isPositive
            ifFalse: [self error: '1 is not positive'].
        one isNegative not
            ifFalse: [self error: '1 is negative'].
        one isZero not
            ifFalse: [self error: '1 is zero'].
        mOne isNegative
            ifFalse: [self error: '-1 is not negative'].
        mOne isPositive not
            ifFalse: [self error: '-1 is positive'].
        mOne isZero not
            ifFalse: [self error: '-1 is zero'].

        (zero at: 1) = $0
            ifFalse: [self error: 'first digit of 0 is not 0'].
        (zero at: 2) = $0
            ifFalse: [self error: 'second digit of 0 is not 0'].
        (twotwotwo at: 1) = $2
            ifFalse: [self error: 'first digit of 222 is not 2'].
        (twotwotwo at: 2) = $2
            ifFalse: [self error: 'second digit of 222 is not 2'].
        (twotwotwo at: 3) = $2
            ifFalse: [self error: 'third digit of 222 is not 2'].
        (twotwotwo at: 4) = $0
            ifFalse: [self error: 'fourth digit of 222 is not 0'].

        zero digitCount = 0
            ifFalse: [self error: 'digit count of 0 is not 0'].
        one digitCount = 1
            ifFalse: [self error: 'digit count of 1 is not 1'].
        zOne digitCount = 1
            ifFalse: [self error: 'digit count of 01 is not 1'].
        two digitCount = 1
            ifFalse: [self error: 'digit count of 2 is not 1'].
        twotwotwo digitCount = 3
            ifFalse: [self error: 'digit count of 222 is not 3'].

        zero + one = one
            ifFalse: [self error: '0 + 1 ~= 1'].
        one + one = two
            ifFalse: [self error: '1 + 1 ~= 2'].
        one + nine = ten
            ifFalse: [self error: '1 + 9 ~= 10'].
        nine + one = ten
            ifFalse: [self error: '9 + 1 ~= 10'].
       
        one - one = zero
            ifFalse: [self error: '1 - 1 ~= 0'].
        two - one = one
            ifFalse: [self error: '2 - 1 ~= 1'].
        ten - nine = one
            ifFalse: [self error: '10 - 9 ~= 1'].
        ten - one = nine
            ifFalse: [self error: '10 - 1 ~= 9'].
        nine - ten = mOne
            ifFalse: [self error: '9 - 10 ~= -1'].
        zero - one = mOne
            ifFalse: [self error: '0 - 1 ~= -1'].

        zero * one = zero
            ifFalse: [self error: '0 * 1 ~= 0'].
        one * one = one
            ifFalse: [self error: '1 * 1 ~= 1'].
        one * nine = nine
            ifFalse: [self error: '1 * 9 ~= 9'].
        nine * one = nine
            ifFalse: [self error: '9 * 1 ~= 9'].
        two * five = ten
            ifFalse: [self error: '2 * 5 ~= 10'].
        twotwotwo * twotwotwo = twotwotwosq
            ifFalse: [self error: '222 * 222 ~= 49284'].

        1000 timesRepeat: [self randomTestSlowInteger]
    ]

    Tester class >> randomTestSlowInteger [
        "operations < + - *"
        | num1 num2 radix snum1 snum2 eStream |
        radix := Random between: 2 and: 36.
        num1 := Random between: -10000 and: 10000.
        num2 := Random between: -10000 and: 10000.
        snum1 := SlowInteger from: num1 usingRadix: radix.
        snum2 := SlowInteger from: num2 usingRadix: radix.
        eStream := WriteStream on: String new.
        'Error comparing ' displayOn: eStream.
        num1 displayOn: eStream.
        ' and ' displayOn: eStream.
        num2 displayOn: eStream.
        ' on base ' displayOn: eStream.
        radix displayOn: eStream.
        ': ' displayOn: eStream.
        (num1 < num2) = (snum1 < snum2)
            ifFalse: ['< operator' displayOn: eStream. self error: eStream contents].
        (num1 + num2) = (snum1 + snum2) asInteger
            ifFalse: ['+ operator' displayOn: eStream. self error: eStream contents].
        (num1 - num2) = (snum1 - snum2) asInteger
            ifFalse: ['- operator' displayOn: eStream. self error: eStream contents].
        (num1 * num2) = (snum1 * snum2) asInteger
            ifFalse: ['* operator' displayOn: eStream. self error: eStream contents].
    ]
]

Tester all
