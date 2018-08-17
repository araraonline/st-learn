#! /usr/bin/gst -f


| sum N |

'Enter your number:' displayNl.
N := stdin nextLine asInteger.

sum := 0.
1 to: N do: [:x | sum := sum + x].

'The sum of numbers from 1 to ' display.
N display.
' is: ' display.
sum displayNl
