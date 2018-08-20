#! /usr/bin/gst -f


String subclass: MyString [

    <shape: #inherit>
    
    checkPalindrome [
        "Check if a string is a palindrome"
        
        <category: 'tests'>
        | block |
        block := [:i |
            | elem1 elem2 |
            elem1 := self at: i.
            elem2 := self at: (self size + 1 - i).
            (elem1 = elem2) ifFalse: [^false]
        ].
        1 to: (self size // 2) do: block.
        ^true
    ]

    displayIfPalindrome [
        "Display the string and whether it is a palindrome or not"
        
        <category: 'printing'>
        self checkPalindrome
            ifTrue: [self print. ' is a palindrome.' displayNl.]
            ifFalse: [self print. ' is not a palindrome.' displayNl.]
    ]
]


(MyString from: 'string') displayIfPalindrome.
(MyString from: 'taco cat') displayIfPalindrome.
(MyString from: 'madam') displayIfPalindrome.
(MyString from: 'tacocat') displayIfPalindrome.
