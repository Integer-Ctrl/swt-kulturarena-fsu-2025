BASE             <http://example.org/kulturarena/>
PREFIX bd:       <http://www.bigdata.com/rdf#>
PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
PREFIX wd:       <http://www.wikidata.org/entity/>
PREFIX wdt:      <http://www.wikidata.org/prop/direct/>
PREFIX wikibase: <http://wikiba.se/ontology#>

SELECT DISTINCT *
WHERE {
  # WHERE Klausel der Anfrage nach den bereits vorhandenen Informationen

  SERVICE <https://query.wikidata.org/sparql> {
    # WHERE Klausesl der Wikidata-Anfrage
  }

  
}