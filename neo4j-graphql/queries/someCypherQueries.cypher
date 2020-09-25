//get the route from The Pond to Dancing Crane Cafe
MATCH (p1:PointOfInterest {name: "The Pond"})
MATCH (p2:PointOfInterest {name: "Dancing Crane Cafe"})
MATCH p=shortestPath((p1)-[:ROUTE*..200]-(p2))
RETURN p

//GPS coordinates to the route above
MATCH (p1:PointOfInterest {name: "The Pond"})
MATCH (p2:PointOfInterest {name: "Dancing Crane Cafe"})
MATCH p=shortestPath((p1)-[:ROUTE*..200]-(p2))
UNWIND nodes(p) AS n
RETURN {latitude: n.location.latitude, longitude: n.location.longitude}

//change the node_osm_id to String to match the definitions in the GraphQL, otherwise it doesn'r work
MATCH (p:PointOfInterest)
SET p.node_osm_id = toString(p.node_osm_id)

//tags than have wikipidia info
MATCH (p:PointOfInterest)--(t:OSMTags)
WHERE EXISTS(t.wikipedia)
RETURN t

//returns information from wikipedia related to the point of interest
MATCH (p:PointOfInterest)--(t:OSMTags)
WHERE EXISTS(t.wikipedia) WITH t LIMIT 1
CALL apoc.load.json('https://en.wikipedia.org/w/api.php?action=parse&prop=text&format.version=2&format=json&page='+ apoc.text.urlencode(t.wikipedia)) YIELD value
RETURN value.parse.text
