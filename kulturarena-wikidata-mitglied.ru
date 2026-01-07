BASE             <http://example.org/kulturarena/>
PREFIX :         <http://example.org/kulturarena/>
PREFIX bd:       <http://www.bigdata.com/rdf#>
PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd:       <http://www.wikidata.org/entity/>
PREFIX wdt:      <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX xsd:      <http://www.w3.org/2001/XMLSchema#>

INSERT {
  ?act a ?soloOrEnsemble .

  ?act :hasGenre ?genreIRI ;
       :musicBrainzId ?mbid .

  ?genreIRI a :Genre ;
            rdfs:label ?genreLabel .

  ?act :hasMember ?memberWD .
  ?memberWD a :Musician ;
            :personName ?memberName ;
            :memberOf ?act ;
            :birthDate ?birthYear ;
            :hasGender ?genderInd .

  ?country :population ?popInt .
}
WHERE {
  ?act a :MusicAct ;
       rdfs:label ?name ;
       :hasOriginCountry ?country .
  ?country rdfs:label ?landLabel .

  FILTER(lang(?name) = "de")
  FILTER(lang(?landLabel) = "de")

  # nicht erneut typisieren
  FILTER NOT EXISTS { ?act a :SoloArtist }
  FILTER NOT EXISTS { ?act a :Ensemble }

  SERVICE <https://query.wikidata.org/sparql> {
    ?darbieter rdfs:label ?name .
    FILTER(lang(?name) = "de")
    FILTER(?darbieter != wd:Q1403672)

    # Herkunftsland (P495)
    ?darbieter wdt:P495 ?wdLand .
    ?wdLand rdfs:label ?landLabel .
    FILTER(lang(?landLabel) = "de")

    # Genre + MBID + Population (optional)
    OPTIONAL { ?darbieter wdt:P136 ?genre . }
    OPTIONAL { ?darbieter wdt:P434 ?mbid . }
    OPTIONAL { ?wdLand wdt:P1082 ?popRaw . }

    # Q5-Check (Flag)
    OPTIONAL { ?darbieter wdt:P31 wd:Q5 . BIND(true AS ?isHuman) }

    # Mitglieder (optional)
    OPTIONAL {
      ?darbieter wdt:P527 ?memberWD .
      OPTIONAL { ?memberWD wdt:P21  ?wdGender . }
      OPTIONAL { ?memberWD wdt:P569 ?birthDate . }

      SERVICE wikibase:label {
        bd:serviceParam wikibase:language "de" .
        ?memberWD rdfs:label ?memberLabel .
      }
    }

    SERVICE wikibase:label {
      bd:serviceParam wikibase:language "de" .
      ?genre rdfs:label ?genreLabel .
    }
  }

  # Typisierung: Q5 => SoloArtist, sonst Ensemble
  BIND(IF(BOUND(?isHuman), :SoloArtist, :Ensemble) AS ?soloOrEnsemble)

  # Genre IRI nur wenn Label vorhanden
  OPTIONAL {
    FILTER(BOUND(?genreLabel))
    BIND(
      IRI(CONCAT(STR(:), "Genre_", REPLACE(STR(?genreLabel), "[^a-zA-Z0-9]", "")))
      AS ?genreIRI
    )
  }

  BIND(STRLANG(STR(?memberLabel), "de") AS ?memberName)
  BIND(STRDT(STR(YEAR(?birthDate)), xsd:gYear) AS ?birthYear)

  OPTIONAL { FILTER(?wdGender = wd:Q6581072) BIND(:Female AS ?genderInd) }
  OPTIONAL { FILTER(?wdGender = wd:Q6581097) BIND(:Male   AS ?genderInd) }

  BIND(xsd:integer(?popRaw) AS ?popInt)

  # nur wenn wirklich etwas eingefügt würde
  FILTER(
    BOUND(?genreIRI) ||
    BOUND(?mbid)     ||
    BOUND(?memberWD) ||
    BOUND(?popInt)   ||
    BOUND(?soloOrEnsemble)
  )
}
