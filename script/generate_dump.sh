#Generate dumps
cd /usr/local/projects/kerameikos
echo "Generating RDF/XML."
java -jar script/saxon9.jar -s:config.xml -xsl:ui/xslt/apis/aggregate-all.xsl -o:dump/kerameikos.org.rdf
echo "Done."
#use wrapper to generate TTL
echo "Generating Turtle."
rapper -i rdfxml -o turtle dump/kerameikos.org.rdf > dump/kerameikos.org.ttl
echo "Done."
#use saxon to create JSON-LD
echo "Generating JSON-LD."
java -jar script/saxon9.jar -s:dump/kerameikos.org.rdf -xsl:ui/xslt/serializations/rdf/json-ld.xsl -o:dump/kerameikos.org.jsonld
echo "Done."
echo "Process complete."
