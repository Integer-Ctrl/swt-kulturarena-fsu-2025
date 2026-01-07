BASE             <http://example.org/kulturarena/>
PREFIX :         <http://example.org/kulturarena/>
PREFIX bd:       <http://www.bigdata.com/rdf#>
PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd:       <http://www.wikidata.org/entity/>
PREFIX wdt:      <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX xsd:      <http://www.w3.org/2001/XMLSchema#>

INSERT {
  # Ist auf jeden Fall ein SoloArtist, da Daten nur an Person stehen
  ?act a :SoloArtist .

  ?act :hasGenre ?genreIRI ;
       :musicBrainzId ?musicBrainzArtistId ;
       :hasMember ?personIRI .

  ?genreIRI a :Genre ;
            rdfs:label ?genreLabel .

  ?personIRI a :Musician ;
             :personName ?personName ;
             :memberOf ?act ;
             :birthDate ?birthYear ;
             :hasGender ?genderInd .
}
WHERE {
  ?act a :MusicAct ;
       rdfs:label ?name ;
       :hasOriginCountry ?country .
  ?country rdfs:label ?landLabel .

  FILTER(lang(?name) = "de")
  FILTER(lang(?landLabel) = "de")

  FILTER NOT EXISTS { ?act a :Ensemble }

  SERVICE <https://query.wikidata.org/sparql> {
    ?darbieter wdt:P31 wd:Q5 ;
               wdt:P106/wdt:P279* wd:Q639669 ;
               wdt:P27 ?wdHerkunftsland ;
               rdfs:label ?name .

    OPTIONAL { ?darbieter wdt:P21 ?geschlecht . }
    OPTIONAL { ?darbieter wdt:P569 ?geburtsdatum . }
    OPTIONAL { ?darbieter wdt:P136 ?genre . }
    OPTIONAL { ?darbieter wdt:P434 ?musicBrainzArtistId . }

    FILTER (?darbieter != wd:Q1403672 )

    ?wdHerkunftsland rdfs:label ?landLabel .
    FILTER(lang(?landLabel) = "de")

    SERVICE wikibase:label {
      bd:serviceParam wikibase:language "de" .
      ?genre rdfs:label ?genreLabel .
      ?geschlecht rdfs:label ?geschlechtLabel .
    }
  }

  # Person IRI aus Wikidata QID
  BIND(?darbieter AS ?personIRI)
  BIND(STRLANG(STR(?name), "de") AS ?personName)

  # birthYear
  BIND(STRDT(STR(YEAR(?geburtsdatum)), xsd:gYear) AS ?birthYear)

  # genderInd nur binden, wenn geschlecht existiert und male/female ist
  OPTIONAL {
    FILTER(?geschlecht = wd:Q6581072)
    BIND(:Female AS ?genderInd)
  }
  OPTIONAL {
    FILTER(?geschlecht = wd:Q6581097)
    BIND(:Male AS ?genderInd)
  }

  # genreIRI
  BIND(IRI(CONCAT(STR(:), "Genre_", REPLACE(STR(?genreLabel), "[^a-zA-Z0-9]", ""))) AS ?genreIRI)
}
