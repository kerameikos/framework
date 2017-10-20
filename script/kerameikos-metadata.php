<?php 
/** Author: Ethan Gruber
 * Date: October 2017
 * Function: Post-process CSV files after Open Refine coreferencing to eliminate duplicate rows and extract skos:definition, skos:broader
 * from Kerameikos
 */

$type = 'shape';
$data = generate_json($type . '.csv');
$labels = array();
$results = array();

foreach ($data as $row){
	if (!in_array($row['Preferred Label'], $labels)){
		$id = $row['id'];
		$label = $row['Preferred Label'];
		echo "Processing {$label}\n";
		
		$result = array();
		$result['id'] = $id;
		$result['prefLabel'] = $label;
		
		//get JSON-LD
		
		if (strlen($id) > 0){
			$json = file_get_contents('http://kerameikos.org/id/' . $id . '.jsonld');
			$obj = json_decode($json);
			
			$object = $obj->{'@graph'}[0];
			
			//definition
			$result['definition'] = $object->{'skos:definition'}[0]->{'@value'};
			
			//broader concept
			if (property_exists($object, 'skos:broader')){
				$broader = array();
				foreach ($object->{'skos:broader'} as $v){
					$broader[] = $v->{'@id'};
				}
				$result['broader'] = implode('|', $broader);
			} else {
				$result['broader'] = '';
			}
		} else {
			$result['definition'] = '';
			$result['broader'] = '';
		}
		
		$result['wikidata'] = $row['Wikidata URI'];
		$result['getty'] = $row['Getty URI'];
		$results[] = $result;		
		
		//add label to array
		$labels[] = $row['Preferred Label'];
	}
}


//write CSV
write_csv($type, $results);


/***** FUNCTIONS *****/
function write_csv($type, $results){
	$heading = array('id','prefLabel', 'definition', 'broader', 'Wikidata URI', 'Getty URI');
	
	$file = fopen($type . '-done.csv', 'w');
	
	fputcsv($file, $heading);
	foreach ($results as $row) {
		fputcsv($file, $row);
	}
	
	fclose($file);
}

function generate_json($doc){
	$keys = array();
	$geoData = array();
	
	$data = csvToArray($doc, ',');
	
	// Set number of elements (minus 1 because we shift off the first row)
	$count = count($data) - 1;
	
	//Use first row for names
	$labels = array_shift($data);
	
	foreach ($labels as $label) {
		$keys[] = $label;
	}
	
	// Bring it all together
	for ($j = 0; $j < $count; $j++) {
		$d = array_combine($keys, $data[$j]);
		$geoData[$j] = $d;
	}
	return $geoData;
}

// Function to convert CSV into associative array
function csvToArray($file, $delimiter) {
	if (($handle = fopen($file, 'r')) !== FALSE) {
		$i = 0;
		while (($lineArray = fgetcsv($handle, 4000, $delimiter, '"')) !== FALSE) {
			for ($j = 0; $j < count($lineArray); $j++) {
				$arr[$i][$j] = $lineArray[$j];
			}
			$i++;
		}
		fclose($handle);
	}
	return $arr;
}

?>