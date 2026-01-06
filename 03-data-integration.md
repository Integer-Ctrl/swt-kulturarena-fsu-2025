3.2:

```
PREFIX ex:   <http://example.org/kulturarena/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT DISTINCT ?act ?name ?country ?countryLabel
WHERE {
  ?act a ex:MusicAct ;
       ex:actName ?name .
  OPTIONAL {
    ?act ex:hasOriginCountry ?country .
    OPTIONAL { ?country rdfs:label ?countryLabel }
  }
}
ORDER BY LCASE(STR(?name)) LCASE(STR(?countryLabel))
```

3.3:

```
PREFIX bd:       <http://www.bigdata.com/rdf#>
PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd:       <http://www.wikidata.org/entity/>
PREFIX wdt:      <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>

SELECT DISTINCT ?name ?landLabel ?darbieter ?darbieterLabel ?country ?countryLabel ?mbid ?genre ?genreLabel
WHERE {
  VALUES (?name ?landLabel) {
    ("BOY"@de "Deutschland"@de)
    ("BOY"@de "Schweiz"@de)
    ("De-Phazz"@de "Deutschland"@de)
    ("Yasmine Hamdan"@de "Libanon"@de)
  }

  # Kandidaten über deutsches Label
  ?darbieter rdfs:label ?name .
  FILTER(lang(?name) = "de")

  # Person ODER Musikgruppe, und dazu das passende "Herkunftsland"
  {
    # Personen: Staatsbürgerschaft (P27)
    ?darbieter wdt:P31 wd:Q5 ;
               wdt:P27 ?country .
  }
  UNION
  {
    # Musikgruppen: Herkunftsland (P495)
    ?darbieter wdt:P31/wdt:P279* wd:Q215380 ;
               wdt:P495 ?country .
  }

  # Herkunftslandlabel muss passen
  ?country rdfs:label ?countryLabel .
  FILTER(lang(?countryLabel) = "de")
  FILTER(?countryLabel = ?landLabel)

  # Vorgabe aus der Aufgabe
  FILTER (?darbieter != wd:Q1403672)

  OPTIONAL { ?darbieter wdt:P434 ?mbid }
  OPTIONAL { ?darbieter wdt:P136 ?genre }

  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "de" .
    # liefert ?darbieterLabel und ?genreLabel automatisch
  }
}
ORDER BY ?name ?landLabel ?darbieter
```