#! /usr/bin/gst -f


Object subclass: GraphvizHelper [
    generateDotRepresentation: aGraph [
        "Respond with a DOT representation of aGraph,
         in the form of a string"

        <category: 'representation'>
    ]

    putDotRepresentation: aGraph on: aStream [
        "Put the DOT representation of aGraph
         on aStream"

        <category: 'private'>
    ]

    putHeaderOn: aStream [
        "Put a DOT header on aStream"

        <category: 'private'>
    ]

    putFooterOn: aStream [
        "Put a DOT footer on aStream"

        <category: 'private'>
    ]

    putNode: nodeName withValue: nodeValue on: aStream [
        "Put the DOT representation of a node
         (single line) on aStream"

        <category: 'private'>
    ]

    putEdge: edgeString withValue: edgeValue on: aStream [
        "Put the DOT representation of an edge
         (single line) on aStream"

        <category: 'private'>
    ]
]
