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

    nodesAndValues [
        "Answer with a LookupTable linking nodes
         to their values. Nodes whose value have
         not been set will have a corresponding
         value of nil."

        <category: 'nodes'>
        ^nodeValues copy
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

    edgesAndValues [
        "Answer with a LookupTable linking edges
         to their values. Edges whose value have
         not been set will have a corresponding
         value of nil."

        <category: 'edges'>
        ^edgeValues copy
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

Object subclass: GraphvizHelper [
    printDotRepresentation: aGraph [
        "Print the DOT representation of aGraph"

        <category: 'printing'>
        (self generateDotRepresentation: aGraph) displayNl
    ]

    generateDotRepresentation: aGraph [
        "Respond with a DOT representation of aGraph,
         in the form of a string"

        <category: 'representation'>
        | stream |
        stream := WriteStream on: String new.
        self putDotRepresentation: aGraph on: stream.
        ^stream contents
    ]

    putDotRepresentation: aGraph on: aStream [
        "Put the DOT representation of aGraph
         on aStream"

        <category: 'private'>
        self putHeaderOn: aStream.
        aGraph nodesAndValues keysAndValuesDo:
            [:node :value | self putNode: node withValue: value on: aStream].
        aGraph edgesAndValues keysAndValuesDo:
            [:edge :value | self putEdge: edge withValue: value on: aStream].
        self putFooterOn: aStream
    ]

    putHeaderOn: aStream [
        "Put a DOT header on aStream"

        <category: 'private'>
        'graph {' displayOn: aStream.
        aStream nl
    ]

    putFooterOn: aStream [
        "Put a DOT footer on aStream"

        <category: 'private'>
        '}' displayOn: aStream.
    ]

    putNode: nodeName withValue: nodeValue on: aStream [
        "Put the DOT representation of a node
         (single line) on aStream"

        <category: 'private'>
        aStream tab.
        nodeName displayOn: aStream.
        ' [label="' displayOn: aStream.
        nodeName displayOn: aStream.
        ' - ' displayOn: aStream.
        nodeValue displayOn: aStream.
        '"]' displayOn: aStream.
        ';' displayOn: aStream.
        aStream nl
    ]

    putEdge: edgeString withValue: edgeValue on: aStream [
        "Put the DOT representation of an edge
         (single line) on aStream"

        <category: 'private'>
        | node1 node2 |
        node1 := edgeString at: 1.
        node2 := edgeString at: 2.
        aStream tab.
        node1 displayOn: aStream.
        ' -- ' displayOn: aStream.
        node2 displayOn: aStream.
        edgeValue isNil ifFalse: [
            ' [label="' displayOn: aStream.
            edgeValue displayOn: aStream.
            '"]' displayOn: aStream.
        ].
        ';' displayOn: aStream.
        aStream nl
    ]
]


graph := Graph new.
helper := GraphvizHelper new.

"add nodes"
graph addNode: $a.
graph addNode: $b.
graph addNode: $c.
graph addNode: $d.

"add edges"
graph addEdge: 'ab'.
graph addEdge: 'ac'.

"set node values"
graph setNode: $b value: 2.
graph setNode: $c value: 3.
graph setNode: $d value: 4.

"set edge values"
graph setEdge: 'ba' value: 25.


helper printDotRepresentation: graph
