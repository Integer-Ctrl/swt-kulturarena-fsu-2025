# 4. Einen Reasoner zum Schließen impliziten Wissens einsetzen

1. Falls nötig, erweitern Sie Ihre Ontologie um zusätzliche Axiome, die folgende automatischen Schlüsse ermöglichen:
    - Für grundlegendes & erweitertes Anforderungsniveau (alle Studiengänge):
        - Klassifikation der Musikdarbieter in Solisten und Ensembles
    - Nur für erweitertes Anforderungsniveau (Master-Studiengänge):
        - Klassifikation von Konzerten mit Musikdarbietern aus einem anderen Land als Deutschland als internationales Konzert

2. Verwenden Sie einen Reasoner um Inferenzen zur Laufzeit bei Anfragen zur Verfügung zu stellen.
    1. Starten Sie Fuseki mit dem gegebenen Konfigurationsfile kulturarena-fuseki-configuration.ttl, um Fuseki zu konfigurieren, dass kulturarena-data.ttland kulturarena-ontology-extension.ttl beim Start geladen wird und Fuseki Reasoning auf dem Graphen durchführt:
        
        `apache-jena-fuseki-4.6.1/fuseki-server --conf=kulturarena-fuseki-configuration.ttl`

        - Um zu Überprüfen, ob das Reasoning funktioniert, können Sie auf http://localhost:3030/#/dataset/kulturarena/query die folgenden beiden Anfragen ausführen:

            1. Testdaten einfügen:

                ```                
                PREFIX ex:  <http://example.org/reasoning-test/>
                PREFIX owl: <http://www.w3.org/2002/07/owl#>
                INSERT {
                    ex:a ex:p ex:b .
                    ex:b ex:p ex:c .
                    ex:p a owl:TransitiveProperty .
                } WHERE {}
                ```

            2. Inferenzen prüfen:

                ```
                PREFIX ex: <http://example.org/reasoning-test/>
                ASK WHERE { ex:a ex:p ex:c . }
                ```

    2. Überprüfen Sie die Korrektheit der Inferenzen mit folgenden Anfragen:

        - Für grundlegendes & erweitertes Anforderungsniveau (alle Studiengänge):
            - `SELECT * WHERE { ?solist a <http://example.org/kulturarena/Solist> }` sollte die IRIs von etwa 135 Solisten zurückgeben
            - `SELECT * WHERE { ?solist a <http://example.org/kulturarena/Ensemble> }` sollte die IRIs von etwa 40 Ensembels zurückgeben
        - Nur für erweitertes Anforderungsniveau (Master-Studiengänge):
            - Die für diese Klassifikation erforderlichen Axiome werden von den in Apache Fuseki verfügbaren OWL Reasonern nicht vollständig unterstützt.

3. Verwenden Sie einen Reasoner um Inferenzen vorab zu berechnen und als Datei zur Verfügung zu stellen.
    1. Verwenden Sie ROBOT reason um die Inferenzen für kulturarena-data.ttl und kulturarena-ontology-extension.ttl bereitzustellen:

        ```
        ./robot -vvv \
            merge --input kulturarena-data.ttl \
                --input kulturarena-ontology-extension.ttl \
            reason --reasoner hermit \
                --axiom-generators "SubClass EquivalentClass DisjointClasses ClassAssertion" \
                --output kulturarena-inferred.ttl
        ```

    2. Überprüfen Sie die Korrektheit der Inferenzen:

        - Für grundlegendes & erweitertes Anforderungsniveau (alle Studiengänge):
            - Speichern Sie die Anfrage SELECT * WHERE { ?solist a <http://example.org/kulturarena/Solist> } in der Datei kulturarena-solist.rq und verwenden Sie ROBOT query um die Anfrage auszuführen:

                ```
                ./robot -vvv \
                    query --input kulturarena-inferred.ttl \
                            --query kulturarena-solist.rq kulturarena-solist.csv
                ```
                In der Datei kulturarena-solist.csv sollten anschließend die IRIs von etwa 135 Solisten gespeichert sein.

            - Speichern Sie die Anfrage SELECT * WHERE { ?solist a <http://example.org/kulturarena/Ensemble> } in der Datei kulturarena-ensemble.rq und verwenden Sie ROBOT query um die Anfrage auszuführen:

                ```
                ./robot -vvv \
                    query --input kulturarena-inferred.ttl \
                            --query kulturarena-ensemble.rq kulturarena-ensemble.csv
                ```
                In der Datei kulturarena-ensemble.csv sollten anschließend die IRIs von etwa 40 Ensembels gespeichert sein.

            - Nur für erweitertes Anforderungsniveau (Master-Studiengänge):
                - Speichern Sie die Anfrage SELECT * WHERE { ?internationalesKonzert a <http://example.org/kulturarena/InternationalesKonzert> } in der Datei kulturarena-internationales-konzert.rq und verwenden Sie ROBOT query um die Anfrage auszuführen:

                ```
                ./robot -vvv \
                    query --input kulturarena-inferred.ttl \
                            --query kulturarena-internationales-konzert.rq kulturarena-internationales-konzert.csv
                ```
                In der Datei kulturarena-internationales-konzert.csv sollten anschließend die IRIs von etwa 400 internationalen Konzerten gespeichert sein.

## Abzugeben ist ein .zip Archiv mit folgendem Inhalt:

- kulturarena-ontology.ttl: Die Ontologie im Turtle-Format
- kulturarena-cq<n>.rq: SPARQL-Anfragen (<n> ist Platzhalter für die Competency Question-Nummer)
- kulturarena-website-konzerte.rqg: Konzerte SPARQL-Generate Anfrage
- kulturarena-wikidata-musikdarbieter.ru: Musikdarbieter SPARQL Update Anfrage
- ggf. kulturarena-wikidata-mitglieds.ru: Ensemble-Mitglieder SPARQL Update Anfrage
- kulturarena-data.ttl: Eingepflegte Daten im Turtle-Format
- kulturarena-ontology-extension.ttl: Die Logik-Erweiterung der Ontologie im Turtle-Format
- kulturarena-inferred.ttl: Die Ontologie mit Daten, Erweiterung und Inferenzen im Turtle-Format