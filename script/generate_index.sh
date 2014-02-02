#write xhtml+rdfa file
cd /usr/local/projects/ceramics
echo "Generating Solr XML"
java -jar script/saxon9.jar config.xml script/generate_solr.xsl > add_doc.xml
INDEX=http://localhost:8080/solr/ceramics/update
echo Removing existing documents
curl $INDEX --data-binary '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
curl $INDEX --data-binary '<commit/>' -H 'Content-type:text/xml; charset=utf-8'
echo Posting Solr add document to $INDEX
curl $INDEX --data-binary @add_doc.xml -H 'Content-type:text/xml; charset=utf-8'
curl $INDEX --data-binary '<commit/>' -H 'Content-type:text/xml; charset=utf-8'
curl $INDEX --data-binary '<optimize/>' -H 'Content-type:text/xml; charset=utf-8'
echo "Done. Cleaning up."
rm add_doc.xml
echo "Process complete."