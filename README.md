# SWT Kulturarena FSU 2025

tbd

## Collaboration

To synchronize work on this repository as a team.

### Ontology Modeling Exercise

- [x] Task 1: Classes and Properties
- [x] Task 2: Individuals
- [x] Task 3: Validation and Correction

### SPARQL Exercise

- [x] Task 1: SPARQL-Anfragen für Competency Questions C1 bis C9

#### Open Questions

None.

#### Closed Questions

- OOPS states `:Female` and `:Male` are unconnected ontology elements
    - But `:Female` is used, e.g. `:SonjaGlass :hasGender :Female`, so this is acceptable?
    - Since no male musician is given by Wikidata in our data, `:Male` is currently unused
- Only added information to or about individuals available on Wikidata
    - Ok to leave out information that is not available on Wikidata?
    - E.g. Members of De-Phazz not listed as individual musicians on Wikidata
- Date of birth is currently designed as xsd:date, but sometimes there will be only year information available
    - Should we change the range?
    - E.g. Yasmine Hamdan only has year of birth listed on Wikidata
- Designed SoloArtist as a subclass of MusicAct and not a subclass of Musician
    - Is this acceptable?
    - E.g. Name of the Musician is also the name of the SoloArtist act
    - E.g. vice versa the SoloArtist (MusicAct) can have another name than the Musician