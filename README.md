# Process
Time tracking:
* 07:30 - 

## Ontology: movie.ttl

Existing classes:
```
arq --data=movie.ttl --query=queries/all_classes.rq --results=text
------------------
| class          |
==================
| :Writer        |
| foaf:Person    |
| :Genre         |
| :FilmStudio    |
| :Actor         |
| :Movie         |
| :MovieDirector |
------------------
```

To Add Classes & domain propos:
* IMDBResource
* Cast

Propos for Existing classes 

Existing obj props:

```
arq --data=movie.ttl --query=queries/all_obj_props.rq
----------------------------------------------------
| obj_prop          | domain      | range          |
====================================================
| :hasActor         | :Movie      | :Actor         |
| :hasCrew          | :Movie      | foaf:Person    |
| :hasFilmStudio    | :Movie      | :FilmStudio    |
| :hasGenre         | :Movie      | :Genre         |
| :hasMovieDirector | :Movie      | :MovieDirector |
| :hasWriter        | :Movie      | :Writer        |
| :friendOf         | foaf:Person | foaf:Person    |
| foaf:knows        | foaf:Person | foaf:Person    |
----------------------------------------------------
``` 

Existing data props:

```
arq --data=movie.ttl --query=queries/all_data_props.rq
---------------------------------------------------------------------------------
| obj_prop            | domain      | range                                     |
=================================================================================
| :hasEstablishedDate | :FilmStudio |                                           |
| :hasReleaseDate     | :Movie      | <http://www.w3.org/2001/XMLSchema#date>   |
| :hasDateOfBirth     | foaf:Person |                                           |
| :hasGender          | foaf:Person |                                           |
| :hasName            | foaf:Person | <http://www.w3.org/2001/XMLSchema#string> |
---------------------------------------------------------------------------------
```

# Assignment
## Semantization of CSV, JSON

movie.ttl is a partial ontology about movies (plus some instance data at the bottom, ignore it).

You are given some data files:
- 1000_keywords.csv
- 1000_links.csv
- 1000_movies_metadata.csv
- 1000_credits.json
- 1000_movies_metadata.json

## Extend the ontology with extra classes and props

### For CSV files

Movie
- hasName (String)
- hasReleaseDate (Date)
- id (String)
- isAdultMovie (boolean)
- budget (integer)
- homepage (url)
- hasIMDBResource (IMDBResource)
- description (String)
- keyword (String)
- tagline (String)
- revenue (integer)
- runtime (integer)
- hasWikidataLink (url) - OPTIONAL

IMDBResource
- id (String)
- url (String)
- vote_average (float)
- vote_count (integer)

### For JSON files

Movie
- originalTitle (String)
- hasFilmStudio (FilmStudio)
- hasGenre (Genre)
- hasMovieDirector (Director)
- hasWriter (Writer)
- hasActor (Actor)
- hasCast (Cast)
- hasSpokenLanguage (String)
- hasProductionCountry (String)

Actor
- hasName (String)
- hasGender (String)

Genre
- id (Integer)
- hasName (String)

FilmStudio
- id (Integer)
- hasName (String)

Cast
- hasCastActor (Actor)
- hasCastCharacter (String)

### RDFize the CSV and JSON files

RDFize the CSV and JSON files (limited to the movies ontology + your extensions). Mapping notes:

- Be careful to construct appropriate subjects for intermediate nodes
- Be careful about the cardinalities of the relation between the master and intermediate node
- Split multivalued strings (eg "keywords") into multiple values so one can easily search by keyword
- Ensure to emit appropriate datatypes for each literal

Use either OpenRefine, OntoRefine, or RML.
We prefer RML so we can see your scripting skills.

For RML:
- Use the YARRML short-hand notation to define the mappings. Write it by hand, or use Matey
- Use Matey to save it as RML
- Use one of the available implementations, eg caRML, carml-cli, RMLMapper


### Queries

Load the data to GraphDB free and write some queries:
- All actors who played in movies with keyword "toy". Output actor name, movie name, character name
- 10 top-ranked movies (by vote_average) with keyword "toy" that had at least 100 votes (vote_count)
