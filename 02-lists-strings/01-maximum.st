#! /usr/bin/gst -f


arr := { 1 .2 .3 .4 .20 .6 .7 .8 .9 }.

maxTillNow := arr at: 1.
2 to: (arr size) do: [:x |
    otherNumber := arr at: x. 
    maxTillNow := otherNumber max: maxTillNow
].
maxNumber := maxTillNow.
maxNumber printNl
