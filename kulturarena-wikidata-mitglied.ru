BASE             <http://example.org/kulturarena/>
PREFIX :         <http://example.org/kulturarena/>
PREFIX bd:       <http://www.bigdata.com/rdf#>
PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd:       <http://www.wikidata.org/entity/>
PREFIX wdt:      <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX xsd:      <http://www.w3.org/2001/XMLSchema#>

INSERT {
  # Ensemble-Mitglieder (als Wikidata-IRIs)
  ?act :hasMember ?memberWD .

  # Member-Infos (Person)
  ?memberWD a :Musician ;
            :personName ?memberName ;
            :memberOf ?act ;
            :birthDate ?birthYear ;
            :hasGender ?genderInd .

  # Herkunftsland-Population
  ?country :population ?popInt .
}
WHERE {
  ?act a :MusicAct .

  ?act rdfs:label ?name ;
       :hasOriginCountry ?country .
  ?country rdfs:label ?landLabel .

  FILTER(lang(?name) = "de")
  FILTER(lang(?landLabel) = "de")

  # --- Wikidata: Act matchen + Mitglieder + Landpopulation ---
  SERVICE <https://query.wikidata.org/sparql> {
    # Act über deutsches Label matchen
    ?darbieter rdfs:label ?name .
    FILTER(lang(?name) = "de")
    FILTER (?darbieter != wd:Q1403672)

    # Herkunftsland für Gruppen typischerweise P495
    ?darbieter wdt:P495 ?wdLand .
    ?wdLand rdfs:label ?landLabel .
    FILTER(lang(?landLabel) = "de")

    # Population des Landes (optional)
    OPTIONAL { ?wdLand wdt:P1082 ?popRaw . }

    # Mitglieder (optional)
    OPTIONAL { ?darbieter wdt:P527 ?memberWD . }

    # Member-Details (optional)
    OPTIONAL { ?memberWD wdt:P21  ?wdGender . }
    OPTIONAL { ?memberWD wdt:P569 ?birthDate . }

    SERVICE wikibase:label {
      bd:serviceParam wikibase:language "de" .
      ?memberWD rdfs:label ?memberLabel .
    }
  }

  # MemberName als deutsches Literal
  BIND(STRLANG(STR(?memberLabel), "de") AS ?memberName)

  # Birth year (xsd:gYear), nur wenn birthDate vorhanden ist
  BIND(STRDT(STR(YEAR(?birthDate)), xsd:gYear) AS ?birthYear)

  # Gender mapping (nur male/female)
  OPTIONAL { FILTER(?wdGender = wd:Q6581072) BIND(:Female AS ?genderInd) }
  OPTIONAL { FILTER(?wdGender = wd:Q6581097) BIND(:Male   AS ?genderInd) }

  # Population cast (nur wenn vorhanden)
  BIND(xsd:integer(?popRaw) AS ?popInt)
}
