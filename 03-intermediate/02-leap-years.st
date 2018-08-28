#! /usr/bin/gst -f


Object subclass: LeapRule [
    | commonYear factors operations |

    <comment: 'I represent a leap year rule
for an arbitrary planet. My instances know
when there will be leap years and when there
won''t be'>

    errorTolerance := 0.0001.  "error tolerance for our leap year rule, in days"

    LeapRule class >> fromYearLength: yearLength [
        "Calculate a leap rule for an arbitrary
         yearLength. yearLegth is the length of a
         year in fractional days, for example, for
         earth it would be close to 365.2422 days.

         The result of this message is a LeapYearRule
         object."

        <category: 'homework'>
        | operationsStream factorsStream commonYearLength error errorPeriod multiplier operation |
        commonYearLength := yearLength rounded.
        error := yearLength asFraction - commonYearLength.  "use fraction to get rid of floating point approximations"
        errorPeriod := 1.  "error that accumulates in each year (1)"
        operationsStream := Array new writeStream.
        factorsStream := Array new writeStream.
        [error abs > errorTolerance] whileTrue: [
            multiplier := 1 // error abs.
            error := error * multiplier.
            errorPeriod := errorPeriod * multiplier.
            operation := 1 withSignOf: error.
            operationsStream nextPut: operation.
            factorsStream nextPut: errorPeriod.
            error := error - (operation).
        ].
        ^self
            fromFactors: factorsStream contents
            andOperations: operationsStream contents
            commonYear: commonYearLength
    ]

    LeapRule class >> fromFactors: factors andOperations: operations commonYear: commonYearLength [
        "Please read setFactors and setOperations for more info"

        <category: 'instance creation'>
        ^self new
            setFactors: factors;
            setOperations: operations;
            setCommonYear: commonYearLength;
            yourself
    ]

    setCommonYear: yearLength [
        "Set the common year length to an integer,
         corresponding to the number of days"

        <category: 'private'>
        commonYear := yearLength
    ]

    setFactors: factorsArray [
        "This will set the internal list of factors
         for which the leap year rule must be considered.
         For example, in earth this value would be equal to
         #(4 100 400), meaning the leap rule must be considered
         for years multiple of 4, 100 and 400."

        <category: 'private'>
        factors := factorsArray
    ]

    setOperations: operationsArray [
        "This message sets the list of operations that should
         be performed on years that are multiple of factors
         (setFactors). For example, in earth this array would
         equal #(1 -1 1), indicating that we should add one day
         on years that are multiple of 4 and so on...

         Notice that the values are additive, so, if two rules happen
         to fall on the same year, they are added (this is the reason
         we use -1 instead of 0 to indicate a non-leap year)"

        <category: 'private'>
        operations := operationsArray
    ]

    displayOn: aStream [
        "Make me display the leap rule on aStream"

        <category: 'printing'>
        aStream next: 20 put: $-; nl.
        'Common year length: ' displayOn: aStream.
        commonYear displayOn: aStream.
        aStream nl.
        aStream nl.

        1 to: factors size do: [:i |
            | factor operation |
            factor := factors at: i.
            operation := operations at: i.

            'Years multiple of ' displayOn: aStream.
            factor displayOn: aStream.
            ': ' displayOn: aStream.

            operation strictlyPositive ifTrue: ['+' displayOn: aStream].
            operation displayOn: aStream.
            aStream nl.
        ].

        aStream next: 20 put: $-; nl.
    ]
].

(LeapRule fromYearLength: 365.2422) display

"365.2422 is the length of one year in earth

By using the generated rule (4 128 80000), even removing the last element,
we get a much closer rule than the actual (4 100 400) rule.

We expect each year to have on average:

- First method (4 100 400): 365 + 1/4 - 1/100 + 1/400 = 365.24250 days
- Second method (4 128): 365 + 1/4 - 1/128 = 365.24218
- Third method (4 128 80000): 365 + 1/4 - 1/128 + 1/80000 = 365.24220

There might be another methods where we can get closer to 0 error in fewer
interactions, but this is a greedy one and it works nicely!"
