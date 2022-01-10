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

## data sources structures
**1000_movies_metadata.csv**
* adult
* budget
* homepage
* id
* imdb_id
* original_language
* original_title
* overview
* popularity
* poster_path
* release_date
* revenue
* runtime
* status
* tagline
* title
* video
* vote_average
* vote_count

**1000_keywords.csv**
* id
* keywords

Example: 
* col1: `862`	
* col2: `[{'id': 931, 'name': 'jealousy'}, {'id': 4290, 'name': 'toy'}, {'id': 5202, 'name': 'boy'}, {'id': 6054, 'name': 'friendship'}, {'id': 9713, 'name': 'friends'}, {'id': 9823, 'name': 'rivalry'}, {'id': 165503, 'name': 'boy next door'}, {'id': 170722, 'name': 'new toy'}, {'id': 187065, 'name': 'toy comes to life'}]`

**1000_links.csv**
* movieId
* imdbId
* imdb_url
* id

Example:
`1,0114709,https://www.imdb.com/title/tt0114709,862`

**1000_movies_metadata.json**
* all parent keys: ['genres', 'id', 'imdb_id', 'original_title', 'production_companies', 'production_countries', 'spoken_languages']

```json
{
  "genres": [
    {
      "id": 16,
      "name": "Animation"
    },
    {
      "id": 35,
      "name": "Comedy"
    },
    {
      "id": 10751,
      "name": "Family"
    }
  ],
  "id": "862",
  "imdb_id": "tt0114709",
  "original_title": "Toy Story",
  "production_companies": [
    {
      "name": "Pixar Animation Studios",
      "id": 3
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "spoken_languages": [
    {
      "iso_639_1": "en",
      "name": "English"
    }
  ]
}
```

**1000_credits.json**
* ['cast', 'crew', 'id']

```json
{
  "cast": [
    {
      "cast_id": 14,
      "character": "Woody (voice)",
      "credit_id": "52fe4284c3a36847f8024f95",
      "gender": 2,
      "id": 31,
      "name": "Tom Hanks",
      "order": 0,
      "profile_path": "/pQFoyx7rp09CJTAb932F2g8Nlho.jpg"
    },
    ...
  ],
  "crew": [
    {
      "credit_id": "52fe4284c3a36847f8024f49",
      "department": "Directing",
      "gender": 2,
      "id": 7879,:hasName
      "job": "Director",
      "name": "John Lasseter",
      "profile_path": "/7EdqiNbr4FRjIhKHyPPdFfEEEFG.jpg"
    },
    {
      "credit_id": "52fe4284c3a36847f8024f4f",
      "department": "Writing",
      "gender": 2,
      "id": 12891,
      "job": "Screenplay",
      "name": "Joss Whedon",
      "profile_path": "/dTiVsuaTVTeGmvkhcyJvKp2A5kr.jpg"
    },
   ...
  ],
  "id": 862
}

```



CSV entries are connected via `id`


### questions/issue

**Cardinality** 

CSV files: Movie (1000_movies_metadata.csv):
- hasWikidataLink (url) - OPTIONAL

Does `OPTIONAL` mean that the cardinality of all other properties of this class is `min/exact:1` ?

The reason for asking is that, other properties/columns from this data source, such as `tagline` and `homepage`, do not always having values `1000_movies_metadata.csv`. Hence if a owl cardinality `min/exact:1` is imposed, the resulting graph will break it.


Another question related to hasWikidataLink prop is, whether I should supplement tha graph with the values for that prop, since they are not present in the CSV





> - Be careful to construct appropriate subjects for intermediate nodes
> - Be careful about the cardinalities of the relation between the master and intermediate node


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
# TODO:
- [ ] Cardinality: remove / update cardinality on Movie domain properties
* [ ] remove named individuals of class 
    * [ ] :Genre (they miss Genre id property)
    * [ ] :FilmStudio (they miss Genre id property)
* [ ] (remove unused props foaf:knows :friendOf)
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
