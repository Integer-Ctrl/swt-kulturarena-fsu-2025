# Modellieren Sie eine Ontologie über Konzerte der Kulturarena

## Modellieren Sie alle erforderlichen Klassen und Properties (TBox) für ein RDF Vokabular zur Repräsentation von Konzerten der Kulturarena.
Folgende Anforderungen sind zu beachten:

- Für grundlegendes & erweitertes Anforderungsniveau (alle Studiengänge):
  - CQ1: Welche Musikdarbieter (Solist*innen oder Ensembles) traten im Jahr 2015 auf?
  - CQ2: Wie oft ist der Musikdarbieter mit dem Namen BOY aufgetreten?
  - CQ3: Wieviele Konzerte mit Musikdarbietern aus welchen Ländern fanden im Jahr 2015 statt?
  - CQ4: Mit Musikdarbietern aus welchem Land fanden bisher die meisten Konzerte statt?
  - CQ5: Welchem Genre ist der Musikdarbieter mit dem Namen Yasmine Hamdan zuzuordnen und wie lautet die MusicBrainz artist ID?
  - CQ6: Die zeitlich direkt aufeinanderfolgenden Konzerte welcher Musikdarbieter lagen die meisten Jahre auseinander und wieviele Jahre?
  - CQ7: Wie hoch ist der Frauenanteil und Männeranteil unter den Musikdarbietern (Solist*innen und Ensemble-Mitglieder), bei denen Daten zum Geschlecht vorliegen, je Jahr?
  - CQ8: Welche Musikdarbieter stammen aus dem bevölkerungsreichsten vertretenen Land?
  - CQ9: In welchem Jahr war das durchschnittliche Alter (Jahr des Konzerts minus Jahr der Geburt) unter den Musikdarbietern (Solist*innen und Ensemble-Mitglieder), bei denen Daten zum Alter vorliegen, am höchsten?

- Speicher Sie die Ontologie in der Turtle-Syntax in der Datei kulturarena-ontology.ttl.

- Beschränken Sie sich bei der Beschreibung der Properties auf Label, Comment, Domain, Range und (ggf.) funktional, um im späteren Projektverlauf performantes Reasoning zu gewährleisten.

- Verwenden Sie http://example.org/kulturarena/ als Ontology IRI und Namespace.

- Zum Schreiben der Ontologie können Sie einen beliebigen Text-Editor (z.B. Notepad++, Kate, …) verwenden. Die Syntax können Sie beispielsweise mir dem Online-Tool SPARQLer Data Validator überprüfen.

- Zur visuellen Überprüfung Ihrer Ontologie können Sie das Online-Werkzeug WebVOWL verwenden.

- Sie können folgende Vorlage als Ausgangspunkt verwenden:

```
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix owl:  <http://www.w3.org/2002/07/owl#> .
@prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
@prefix :     <http://example.org/kulturarena/> .

<http://example.org/kulturarena/> a owl:Ontology ;
    rdfs:label "Kulturarena Ontologie"@de .

:Konzert a owl:Class .
```

## Fügen Sie manuell Instanzen und Aussagen (ABox) für alle Competency Questions Ihres Anforderungsniveaus hinzu.
- Verwenden Sie dazu folgende Konzerte und ggf. zusätzliche Daten von Wikidata:

```
Musiker         Land                  Jahre

BOY	            Deutschland/Schweiz   2012, 2016
De-Phazz        Deutschland	          2001, 2003, 2007
Yasmine Hamdan	Libanon	              2015
```

## Überprüfen Sie Ihre Ontologie und korrigieren Sie sie gegebenenfalls.
- Laden Sie das Kommandozeilen-Werkzeug ROBOT und das ROBOT shell script (Linux) / ROBOT batch script (Windows) herunter.

- Konvertieren Sie Ihre Ontologie mit ROBOT in das RDF/XML-Format. Dabei wird auch die Syntax Ihrer Ontologie überprüft. Sollte Ihre Ontologie syntaktische Fehler enthalten, korrigieren Sie diese zunächst.

  `./robot -vvv convert --input kulturarena-ontology.ttl --output kulturarena-ontology.owl`

- Überprüfen Sie Ihre Ontologie mit dem Onlineservice OOPS! auf semantische Fehler.
  - Verwenden Sie hierbei die Ontologie im RDF/XML-Format, da OOPS! nur dieses Format akzeptiert.
  - Korrigieren Sie alle gefundenen Pitfalls (außer “P13: Inverse relationships not explicitly declared.”, “P41: No license declared.”, Empfehlungen und Pitfalls, die die Benennung externer IRIs betreffen).


## Abzugeben ist:

`kulturarena-ontology.ttl`: Die Ontologie im Turtle-Format

Das Bestehen dieses Projektabschnitts ist Zulassungsvoraussetzung für die Prüfung.