#!/usr/bin/env python
import sys
from rdflib import Graph, plugin
from rdflib.serializer import Serializer

#evaluate the mode
mode = sys.argv[1]

if mode == 'id':
    id = sys.argv[2]
    scheme = sys.argv[3]
    format = sys.argv[4]
    file = "file:///usr/local/projects/kerameikos-data/" + scheme + "/" + id + ".rdf"

    graph = Graph()
    
    graph.parse(file, format='application/rdf+xml')
    
    if format == 'jsonld':
        print(graph.serialize(format='json-ld', indent=4))
    elif format == 'ttl':
        print(graph.serialize(format='text/turtle'))
elif mode == 'dump':    
    format = sys.argv[2]
    inFile = "http://localhost:8080/orbeon/kerameikos/kerameikos.org.rdf"
    
    graph = Graph()
    
    graph.parse(inFile, format='application/rdf+xml')
    
    if format == 'jsonld':
       print(graph.serialize(format='json-ld', indent=4))
    elif format == 'ttl':
        print(graph.serialize(format='text/turtle'))
else: 
    print("Invalid format\n")