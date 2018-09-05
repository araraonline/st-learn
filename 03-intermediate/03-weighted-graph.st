#! /usr/bin/gst -f


Object subclass: Graph [

    <comment: 'I represent a simple weighted graph.'>

    addNode: nodeName [
        "Add a new node with name nodeName.
         nodeName must be a Character."

        <category: 'nodes'>
    ]

    removeNode: nodeName [
        "Remove a node with name nodeName.
         nodeName must be a Character."

        <category: 'nodes'>
    ]

    addEdge: edgeString [
        "Add an edge between two nodes. edgeString is
         a string that is formed by concatenating the
         name of the two  nodes.

         For example, to create a node between $a and $b,
         use the message addEdge: 'ab'."

        <category: 'edges'>
    ]

    removeEdge: edgeString [
        "Remove an edge between two nodes. edgeString is
         a string that is formed by concatenating the
         name of the two  nodes.

         For example, to remove a node between $a and $b,
         use the message removeEdge: 'ab'."

        <category: 'edges'>
    ]

    setNode: nodeName value: nodeValue [
        "Set the value of the node named
         nodeName to nodeValue."

        <category: 'value - setting'>
    ]

    setEdge: edgeString value: edgeValue [
        "Set the value of the edge represented
         by edgeString (e.g. 'ab') to edgeValue."

        <category: 'value - setting'>
    ]

    printInternals [
        "Print my instance variables to see if I'm
         working correctly"

        <category: 'debugging'>
    ]
]
