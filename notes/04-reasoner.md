# Einen Reasoner zum Schließen impliziten Wissens einsetzen

# Task 1: Extension

Siehe `kulturarena-ontology-extension`

## Task 2: Fuseki

### Task 2.1

Beide Anfragen erfolgreich.

### Task 2.2

- `SELECT * WHERE { ?solist a <http://example.org/kulturarena/Solist> }` liefert 145 Ergebnisse. (Vorgabe etwa 135)

- `SELECT * WHERE { ?solist a <http://example.org/kulturarena/Ensemble> }` liefert 133 Ergebnisse. (Vorgabe etwa 40)

    - Da das Ergebnis für Ensembles deutlich höher ist als erwartet, noch die zusätzliche Abfrage, ob es Künstler gibt, die sowohl Solist als auch Ensemble sind:

        ```
        SELECT * WHERE { 
        ?artist a <http://example.org/kulturarena/Solist> .
        ?artist a <http://example.org/kulturarena/Ensemble> .
        }
        ```

        Dies liefert 0 Ergebnisse, also keine Künstler, die sowohl Solist als auch Ensemble sind.

    - **Grund für Abweichung**: in der Update-Query `kulturarena-wikidata-mitglied.ru` wird geprüft ob Instanz vom Typ Person (`Q5`) ist. Falls dies nicht der Fall ist, wird die Instanz als Ensemble klassifiziert. Wenn wir jetzt mit einer Query prüfen, wie viele MusicAtcs mindestens 2 Mitglieder haben, erhalten wir folgendes Ergebnis:

        ```
        PREFIX : <http://example.org/kulturarena/>

        SELECT ?ensemble (COUNT(?member) AS ?anzahlMitglieder)
        WHERE {
        ?ensemble a :Ensemble .
        ?ensemble :hasMember ?member .
        }
        GROUP BY ?ensemble
        HAVING (COUNT(?member) > 1)
        ```

        Dies liefert 38 Ergebnisse, also wesentlich näher an der Vorgabe von etwa 40 Ensembles.

- `SELECT * WHERE { ?internationalesKonzert a <http://example.org/kulturarena/InternationalesKonzert> }` liefet keine Ergebnisse. (Vorgabe etwa 400)

    - **Grund für Fehler**: Die Modellierung der Klasse `InternationalConcert` ist korrektes OWL und funktioniert mit einem vollständigen OWL-DL-Reasoner wie HermiT. In Apache Fuseki wird jedoch der **OWLFBRuleReasoner** verwendet, der nur regelbasiertes Reasoning unterstützt. Dieser Reasoner kann Negationen wie `complementOf` sowie die Aussage "ungleich Deutschland" nicht zuverlässig auswerten, da OWL keine automatische Ungleichheit zwischen verschiedenen Individuen annimmt. Deshalb werden die internationalen Konzerte in Fuseki nicht inferiert, obwohl die Ontologie logisch korrekt ist.

## Task 3: HermiT

Reasoning mit HermiT erfolgreich durchgeführt. Alle drei Anfragen erfolgreich und jeweilige CSV-Dateien mit den Ergebnissen erstellt.

Gleicher Fehler bezüglich der Anzahl an `Ensemble`-Instanzen wie bei Fuseki. Ansonsten alle Ergebnisse wie erwartet.