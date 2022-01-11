
# Dependencies
* GraphDB: 
    * running on port 7200 
    * with a empty repository named *movies*
* python3 
* Docker

# Process

* ontology expansion
    * ouput: [movie.ttl](./movie.ttl)
* Data files (json, csv) added to [data](./data) directory
* RDFize the CSV and JSON files with [run_mapping.sh](./run_mapping.sh) `./run_mapping.sh`
    * uses: rmlio/yarrrml-parser, rmlio/rmlmapper-java, 
    * uses: [scripts/fix_csv.py](.scripts/fix_csv.py)  script to:
        * prevent corrupted entries in `1000_movies_metadata.csv` for making into graph
        * split keywords string from `1000_keywords.csv` into individual keys
    * mapping file: [data/movie_map.yarrr.yml](./data/movie_map.yarrr.yml)
    * output graph: [data/output/all.ttl](./data/output/all.ttl) 
* in GraphDB workbench create the repository `movies` 
* import resulting dataset [data/output/all.ttl](./data/output/all.ttl) to GraphDB repository `movies`


## SPARQL queries:

*All actors who played in movies with keyword "toy". Output actor name, movie name, character name*
* query file: [queries/01_movie_kw_toy.rq](./queries/01_movie_kw_toy.rq)
* query to GraphDB REST API - SPARQL endpoint: [queries/01_api_query.sh](./queries/01_api_query.sh) `./queries/01_api_query.sh`

Results:
```
----------------------------------------------------------------------------------------------
| movie_name    | actor_name          | character_name                                       |
==============================================================================================
| "Toy Story"   | "Annie Potts"       | "Bo Peep (voice)"                                    |
| "Toy Story"   | "Don Rickles"       | "Mr. Potato Head (voice)"                            |
| "Toy Story"   | "Erik von Detten"   | "Sid (voice)"                                        |
| "Toy Story"   | "Jim Varney"        | "Slinky Dog (voice)"                                 |
| "Toy Story"   | "John Morris"       | "Andy (voice)"                                       |
| "Toy Story"   | "John Ratzenberger" | "Hamm (voice)"                                       |
| "Toy Story"   | "Laurie Metcalf"    | "Mrs. Davis (voice)"                                 |
| "Toy Story"   | "Penn Jillette"     | "TV Announcer (voice)"                               |
| "Toy Story"   | "R. Lee Ermey"      | "Sergeant (voice)"                                   |
| "Toy Story"   | "Sarah Freeman"     | "Hannah (voice)"                                     |
| "Toy Story"   | "Tim Allen"         | "Buzz Lightyear (voice)"                             |
| "Toy Story"   | "Tom Hanks"         | "Woody (voice)"                                      |
| "Toy Story"   | "Wallace Shawn"     | "Rex (voice)"                                        |
| "Toy Story 2" | "Andrew Stanton"    | "Emperor Zurg (voice)"                               |
| "Toy Story 2" | "Annie Potts"       | "Bo Peep (voice)"                                    |
| "Toy Story 2" | "Corey Burton"      | "Woody's Roundup Announcer (voice)"                  |
| "Toy Story 2" | "Don Rickles"       | "Mr. Potato Head (voice)"                            |
| "Toy Story 2" | "Estelle Harris"    | "Mrs. Potato Head (voice)"                           |
| "Toy Story 2" | "Jeff Pidgeon"      | "Aliens (voice)"                                     |
| "Toy Story 2" | "Jim Varney"        | "Slinky Dog (voice)"                                 |
| "Toy Story 2" | "Joan Cusack"       | "Jessie (voice)"                                     |
| "Toy Story 2" | "Jodi Benson"       | "Barbie (voice)"                                     |
| "Toy Story 2" | "Joe Ranft"         | "Wheezy (voice)"                                     |
| "Toy Story 2" | "John Lasseter"     | "Blue Rock 'Em Sock 'Em Robot (voice)"               |
| "Toy Story 2" | "John Morris"       | "Andy (voice)"                                       |
| "Toy Story 2" | "John Ratzenberger" | "Hamm (voice)"                                       |
| "Toy Story 2" | "Jonathan Harris"   | "The Cleaner (voice)"                                |
| "Toy Story 2" | "Kelsey Grammer"    | "Prospector (voice)"                                 |
| "Toy Story 2" | "Laurie Metcalf"    | "Andy's Mom (voice)"                                 |
| "Toy Story 2" | "Lee Unkrich"       | "Red Rock 'Em Sock 'Em Robot (voice)"                |
| "Toy Story 2" | "Mickie McGowan"    | "Mom at yard sale (voice)"                           |
| "Toy Story 2" | "Phil Proctor"      | "Airline Rep / sign-off voice / Mr. Konishi (voice)" |
| "Toy Story 2" | "R. Lee Ermey"      | "Sarge (voice)"                                      |
| "Toy Story 2" | "Tim Allen"         | "Buzz Lightyear (voice)"                             |
| "Toy Story 2" | "Tom Hanks"         | "Woody (voice)"                                      |
| "Toy Story 2" | "Wallace Shawn"     | "Rex (voice)"                                        |
| "Toy Story 2" | "Wayne Knight"      | "Al McWhiggin (voice)"                               |
----------------------------------------------------------------------------------------------
```


* 10 top-ranked movies (by vote_average) with keyword "toy" that had at least 100 votes (vote_count)
* query file: [queries/02_10ranked_toy.rq](./queries/02_10ranked_toy.rq)
* query to GraphDB REST API - SPARQL endpoint: [queries/02_api_query.sh](./queries/02_api_query.sh) `sh./queries/02_api_query.sh`

Results:
```
-------------------------------------------------
| movie_name    | vote_count | vote_avg         |
=================================================
| "Toy Story"   | 5415       | "7.7"^^xsd:float |
| "Toy Story 2" | 3914       | "7.3"^^xsd:float |
-------------------------------------------------
``` 


# Bugs:
* in mapping `mo:hasWriter` prop values to `mo:Writer` instances RML is only performing it once
* in mapping [data/1000_movies_metadata.csv](./data/1000_movies_metadata.csv) the values of column `runtime` get converted to floats, despite being original integers and  `datatype:xsd:integer` being used - this results in `mo:runtime "105.0"^^xsd:integer;` which can trow errors in tuple-store/sparql processor. Hence have left it as a float.


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


## Development notes
In [Notes.md](./Notes.md)