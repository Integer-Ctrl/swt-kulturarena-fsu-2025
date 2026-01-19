# Datenabfrage mit SPARQL

Competency Questions in SPARQL-Anfragen übersetzen

## Vorbereitung des SPARQL-Interfaces

1. Downloaden und entpacken Sie Apache Jena Fuseki (Binary Distribution)
2. Starten Sie Fuseki unter Verwendung Ihrer Ontologie als Datenquelle: \
  `apache-jena-fuseki-4.6.1/fuseki-server --file=kulturarena-ontology.ttl /kulturarena`
3. Öffnen Sie das Query-Interface unter http://localhost:3030/#/dataset/kulturarena/query

## Schreiben Sie SPARQL-Anfragen für jede Competency Question Ihres Anforderungsniveaus und speichern Sie diese in separaten Dateien. Es sollen folgende Daten zurückgegeben werden:

- Für grundlegendes & erweitertes Anforderungsniveau (alle Studiengänge):
  - CQ1: Musikdarbietern-IRI, Musikdarbietern-Name
  - CQ2: Anzahl
  - CQ3: Land-IRI, Land-Name, Anzahl
  - CQ4: Land-IRI, Land-Name
  - CQ5: Musikdarbietern-IRI, Genre-Name, MusicBrainz artist ID
  - CQ6: Musikdarbietern-IRI, Abstand
- Nur für erweitertes Anforderungsniveau (Master-Studiengänge):
  - CQ7: Jahr, Frauenanteil, Männeranteil
  - CQ8: Musikdarbietern-IRI, Musikdarbietern-Name, Herkunftsland-Name
  - CQ9: Jahr, Durchschnittsalter

## Abzugeben ist ein .zip Archiv mit folgendem Inhalt:

- `kulturarena-ontology.ttl`: Die Ontologie im Turtle-Format
- `kulturarena-cq<n>.rq`: SPARQL-Anfragen (`<n>` ist Platzhalter für die Competency Question-Nummer)