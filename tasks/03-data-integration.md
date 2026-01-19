# 3. Datenintegration

Pflegen Sie mit Hilfe von SPARQL-Generate und SPARQL Update Daten in die Ontologie ein

1. Downloaden Sie das SPARQL-Generate Executable JAR für die lokale Ausführung der Anfrage. Alternativ kann auch der SPARQL-Generate Playground verwendet werden.

2. Schreiben Sie eine SPARQL-Generate Anfrage um die Übersicht über bisherige Konzerte der Kulturarene (archive.org Backup) in RDF zu konvertieren und führen Sie diese aus:

    `java -jar sparql-generate-2.0.12.jar -q kulturarena-website-konzerte.rqg -o kulturarena-data.ttl -fo TTL -l DEBUG`

    - Hinweis: Verwenden Sie für die Namen der Gäste und der Herkunftsländer LangTags (e.g. "Quadro Nuevo"@de). Das erleichtert das spätere Schreiben der Anfragen für Wikidata.
    - Hinweis: Fehlende Jahre in der Tabelle müssen abgefangen werden, um Probleme in der nächsten Teilaufgabe zu vermeiden.

3. Schreiben Sie eine SPARQL Update Anfrage um Informationen über die Musikdarbieter für Ihre Ontologie aus Wikidata zu laden und führen Sie diese aus:

    ```
    ./robot -vvv \
        merge --input kulturarena-ontology.ttl \
              --input kulturarena-data.ttl \
        query --update kulturarena-wikidata-musikdarbieter.ru \
              --output kulturarena-data.ttl
    ```
    - Ordnen Sie die Resourcen in Wikidata anhand des Namens und des Herkunftslandes zu.
    - Filtern Sie wd:Q1403672 heraus (FILTER (?darbieter != wd:Q1403672 )), um später Probleme beim Reasoning zu vermeiden.
    - Es empfiehlt sich zunächst separate Anfragen für die bereits eingepflegten Daten und für Wikidata zu schreiben, und diese anschließend  kombinieren.
    
      1. Starten Sie Fuseki mit den eingepflegten Daten:

          `apache-jena-fuseki-4.6.1/fuseki-server --file=kulturarena-data.ttl /kulturarena`

      2. Verwenden Sie das Fuseki Query-Interface um eine SELECT Anfrage nach den bereits vorhandenen Informationen über die Resourcen zu schreiben.

          (Beispielhafte Anfrage:)
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

      3. Verwenden Sie das Query-Interface von Wikidata um eine SELECT Anfrage für die benötigten Werte zu schreiben. Nutzen Sie eine VALUES-Klausel um beispielhafte Informationen zur Auswahl der benötigten Resourcen bereitzustellen. Der Wikidata-spezifische Label-SERVICE kann genutzt werden, um Labels in der benötigten Sprache zu erhalten:

          ```
          SELECT *
          WHERE {
            # Anfrage unter Verwendung von ?name und ?landLabel
            SERVICE wikibase:label {
              bd:serviceParam wikibase:language "de".
              # das Label für ?beispiel wird in der Variable ?beispielLabel bereitgestellt ?beispiel rdfs:label ?beispielLabel .
            } 
          }
          VALUES (?name ?landLabel) {
            ("BOY"@de "Deutschland"@de)
            ("BOY"@de "Schweiz"@de)
            ("BOY"@de "Deutschland"@de)
            ("BOY"@de "Schweiz"@de)
            ("De-Phazz"@de "Deutschland"@de)
            ("Felix Meyer"@de "Deutschland"@de)
            ("Yasmine Hamdan"@de "Libanon"@de)
          }
          ```

          (Beispielhafte Anfrage:)
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

      4. Verwenden Sie das Fuseki Query-Interface um eine kombinierte SELECT Anfrage unter Verwendung einer SERVICE Kausel für den Wikidata-Teil zu schreiben:

            ```
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
            ```

      5. Verwenden Sie Fuseki Query-Interface um abschließend die SELECT Anfrage in eine INSERT Anfrage umzuwandeln:

            ```
            BASE             <http://example.org/kulturarena/>
            PREFIX bd:       <http://www.bigdata.com/rdf#>
            PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX wd:       <http://www.wikidata.org/entity/>
            PREFIX wdt:      <http://www.wikidata.org/prop/direct/>
            PREFIX wikibase: <http://wikiba.se/ontology#>

            INSERT {
              # Pattern zum generieren der Triples unter Verwendung der Variablen aus der WHERE Klausel
            }
            WHERE {
              # WHERE Klausel der kombinierten SELECT Anfrage
            }
            ```

4. Nur für erweitertes Anforderungsniveau (Master-Studiengänge): Schreiben Sie eine weitere SPARQL Update Anfrage um Informationen über die Mitglieder und die Heimatländer der Musikdarbieter für Ihre Ontologie aus Wikidata zu laden und führen Sie diese aus:

    ```
    ./robot -vvv \
        query --input kulturarena-data.ttl \
              --update kulturarena-wikidata-mitglied.ru \
              --output kulturarena-data.ttl
    ```

5. Überprüfen Sie Ihre Ergebnisse, indem Sie die SPARQL Anfragen gegen die neuen Daten ausführen:

    `apache-jena-fuseki-4.6.1/fuseki-server --file=kulturarena-data.ttl /kulturarena`

## Abzugeben ist ein .zip Archiv mit folgendem Inhalt:

- kulturarena-ontology.ttl: Die Ontologie im Turtle-Format
- kulturarena-cq<n>.rq: SPARQL-Anfragen (<n> ist Platzhalter für die Competency Question-Nummer)
- kulturarena-website-konzerte.rqg: Konzerte SPARQL-Generate Anfrage
- kulturarena-wikidata-musikdarbieter.ru: Musikdarbieter SPARQL Update Anfrage
- ggf. kulturarena-wikidata-mitglieds.ru: Ensemble-Mitglieder SPARQL Update Anfrage
- kulturarena-data.ttl: Eingepflegte Daten im Turtle-Format