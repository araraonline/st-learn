#! /usr/bin/gst -f


Object subclass: LeapYearRule [
    | commonYearLength initialSignPositive yearFactors |

    <comment: 'I represent a leap year rule
for an arbitrary planet. My instances know
when there will be leap years and when there
won''t be'>

    errorTolerance := 0.0001.  "error tolerance for our leap year rule, in days"

    LeapYearRule class >> fromYearLength: yearLength [
        "Calculate the leap rule for an arbitrary
         yearLength. yearLegth is the length of a
         year in fractional days, for example, for
         earth it would be close to 365.2422 days.

         The result of this message is a LeapYearRule
         object."

        <category: 'homework'>
        | signsStream yearFactorsStream commonYearLength error errorPeriod multiplier |
        commonYearLength := yearLength rounded.
        error := yearLength asFraction - commonYearLength.  "use fraction to get rid of floating point approximations"
        errorPeriod := 1.  "error accumulates for each year (1)"
        signsStream := Array new writeStream.
        yearFactorsStream := Array new writeStream.
        [error abs > errorTolerance] whileTrue: [
            multiplier := 1 // error abs.
            error := error * multiplier.
            errorPeriod := errorPeriod * multiplier.
            signsStream nextPut: error positive.
            yearFactorsStream nextPut: errorPeriod.
            error := error - (1 withSignOf: error).
            multiplier printNl.
            error printNl.
        ].
        " error printNl. "
        signsStream contents printNl.
        yearFactorsStream contents printNl.
    ]

    setInitialSignPositive [
        "Set the initial leap year occasion.
         A positive sign means one day will be
         added to the year. A negative sign
         means one day will be removed from the
         year."

        <category: 'internals'>
    ]

    setInitialSignNegative [
        "Ref: setInitialSignPositive"

        <category: 'internals'>
    ]

    setYearFactors: factors [
        "This will set the internal list of factors
         for which the leap year rule must be considered.
         For example, in earth this value would be equal to
         #(4 100 400), meaning the leap rule must be considered
         for years multiple of 4, 100 and 400."

        <category: 'internals'>
    ]
].

" LeapYearRule fromYearLength: 5.3 "
LeapYearRule fromYearLength: 365.2422
