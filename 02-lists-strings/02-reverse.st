#! /usr/bin/gst -f


Array subclass: MyArray [
    <shape: #inherit>
    reverse [
        "Reverse array in place"
        
        <category: 'utils'>
        | size |
        size := self size.
        1 to: (size // 2) do: [:i |
            self swap: i with: (size - i + 1)
        ]
    ]
    
    swap: i with: j [
        "Swap two items from array"
        
        <category: 'utils'>
        | toI toJ |
        toI := self at: j.
        toJ := self at: i.
        self at: i put: toI.
        self at: j put: toJ
    ]
]

arr := MyArray new: 5.
s := WriteStream on: arr.
s nextPutAll: {1 .2 .3 .4 .5}.
arr reverse.
arr printNl
