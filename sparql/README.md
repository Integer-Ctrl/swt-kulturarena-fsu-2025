# SPARQL Queries for Competency Questions

For competency questions seven and nine, two different queries are provided since the questions can be interpreted in different ways.

## CQ7

`kulturarena-cq7.rq`: Persons are counted per concert. This means that if a musician performed in multiple concerts in a year, this musician is counted multiple times for that year.
`kulturarena-cq7-v2.rq`: Persons are counted per year. This means that if a musician performed in multiple concerts in a year, this musician is counted only once for that year.

## CQ9

`kulturarena-cq9.rq`: The age of a musician (based on the birth year) is calculated per concert. This means that if a musician performed in multiple concerts in a year, this musician's age is counted multiple times for that year.
`kulturarena-cq9-v2.rq`: The age of a musician (based on the birth year) is calculated per year. This means that if a musician performed in multiple concerts in a year, this musician's age is counted only once for that year.