#! /usr/bin/gst -f


| num den total |

total := 0.0.
num := 1.0.
den := 1.0.

1000000 timesRepeat: [
    total := total + (num / den).
    num := num negated.
    den := den + 2
].

total := 4 * total.
total printNl  "aaand the result is close to pi"
