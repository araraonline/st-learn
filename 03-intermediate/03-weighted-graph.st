#! /usr/bin/gst -f


Object subclass: Graph [
    | links nodeValues edgeValues |

    <comment: 'I represent a simple weighted graph.'>

    Graph class >> new [
        "Create a new graph object"

        <category: 'instance creation'>
        ^super new init
    ]

    init [
        "Initialize my instance variables"

        <category: 'private'>
        links := LookupTable new.
        nodeValues := LookupTable new.
        edgeValues := LookupTable new
    ]

    addNode: nodeName [
        "Add a new node with name nodeName.
         nodeName must be a Character."

        <category: 'nodes'>
        (self hasNode: nodeName) ifTrue: [self error: 'node already present'].
        links at: nodeName put: Set new.
        nodeValues at: nodeName put: nil
    ]

    removeNode: nodeName [
        "Remove a node with name nodeName.
         nodeName must be a Character."

        <category: 'nodes'>
        links removeKey: nodeName ifAbsent: [self error: 'node not found'].
        nodeValues removeKey: nodeName
    ]

    addEdge: edgeString [
        "Add an edge between two nodes. edgeString is
         a string that is formed by concatenating the
         name of the two  nodes.

         For example, to create a node between $a and $b,
         use the message addEdge: 'ab'."

        <category: 'edges'>
        | edge node1 node2 |
        edge := edgeString sorted.  "we use sorted edgeStrings for consistency"
        node1 := edge at: 1.
        node2 := edge at: 2.
        (self hasNode: node1) ifFalse: [self error: 'node $', node1 asString, ' not found'].
        (self hasNode: node2) ifFalse: [self error: 'node $', node2 asString, ' not found'].
        (self hasEdge: edge) ifTrue: [self error: 'edge already present'].
        (links at: node1) add: node2.
        (links at: node2) add: node1.
        edgeValues at: edge put: nil
    ]

    removeEdge: edgeString [
        "Remove an edge between two nodes. edgeString is
         a string that is formed by concatenating the
         name of the two  nodes.

         For example, to remove a node between $a and $b,
         use the message removeEdge: 'ab'."

        <category: 'edges'>
        | edge node1 node2 |
        edge := edgeString sorted.  "we use sorted edgeStrings for consistency"
        node1 := edge at: 1.
        node2 := edge at: 2.
        (self hasEdge: edge) ifFalse: [self error: 'edge not found'].
        (links at: node1) remove: node2.
        (links at: node2) remove: node1.
        edgeValues removeKey: edge
    ]

    setNode: nodeName value: nodeValue [
        "Set the value of the node named
         nodeName to nodeValue."

        <category: 'value setting'>
        (self hasNode: nodeName) ifFalse: [self error: 'node not found'].
        nodeValues at: nodeName put: nodeValue
    ]

    setEdge: edgeString value: edgeValue [
        "Set the value of the edge represented
         by edgeString (e.g. 'ab') to edgeValue."

        <category: 'value setting'>
        | edge |
        edge := edgeString sorted.  "we use sorted edgeStrings for consistency"
        (self hasEdge: edge) ifFalse: [self error: 'edge not found'].
        edgeValues at: edge put: edgeValue
    ]

    displayInternals [
        "Display my instance variables to see if I'm
         working correctly"

        <category: 'debugging'>
        'links:' displayNl.
        links displayNl.
        Transcript nl.
        
        'nodeValues:' displayNl.
        nodeValues displayNl.
        Transcript nl.

        'edgeValues:' displayNl.
        edgeValues displayNl.
        Transcript nl
    ]

    hasNode: node [
        "Check if I have the given node"

        <category: 'private'>
        ^nodeValues includesKey: node
    ]

    hasEdge: edge [
        "Check if I have the given edge"

        <category: 'private'>
        ^edgeValues includesKey: edge
    ]
]

graph := Graph new.

"add nodes"
graph addNode: $a.
graph addNode: $b.
graph addNode: $c.
graph addNode: $d.

"add/remove node"
graph addNode: $e.
graph removeNode: $e.

"add edges"
graph addEdge: 'ab'.
graph addEdge: 'ca'.

"add/remove edge"
graph addEdge: 'cd'.
graph removeEdge: 'cd'.

"set node values"
graph setNode: $b value: 0.
graph setNode: $c value: 75.
graph setNode: $d value: 7.

"set edge values"
graph setEdge: 'ba' value: 5.

"break it down"
" graph addNode: $a. "
" graph removeNode: $z. "
" graph addEdge: 'ab'. "
" graph addEdge: 'az'. "
" graph removeEdge: 'az'. "
" graph setNode: $z value: 1. "
" graph setEdge: 'az' value: 1. "

graph displayInternals
