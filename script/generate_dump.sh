#write xhtml+rdfa file
cd /usr/local/projects/ceramics
echo "Generating RDF/XML."
OUTPUT=dump/kerameikos.org.xml
java -jar script/saxon9.jar config.xml script/generate_rdfxml.xsl > $OUTPUT
echo "Done."
echo "Process complete."