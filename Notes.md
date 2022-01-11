# Process Notes 

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

## data sources structures - mapped to properties
**1000_movies_metadata.csv**
* adult - Movie: isAdultMovie (boolean) **Transform** - DONE
* budget - Movie: budget (integer) - DONE
* homepage - Movie: homepage (url) - DONE
* id  - Movie: id (String) - Movie URI - DONE
* imdb_id - hasIMDBResource (IMDBResource)  - mapped to IMDBResource instances - DONE
* original_language - DONE
* original_title - DONE
* overview - Movie: description (String) - DONE
* release_date - Movie: hasReleaseDate (Date) - DONE
* revenue - Movie: revenue (integer) - DONE
* runtime - Movie: runtime (integer) - DONE
* status
* tagline - Movie: tagline (String) - DONE
* title - Movie: hasName (String) - DONE
* video
* vote_average - IMDBResource: vote_average (float) - DONE
* vote_count - IMDBResource: - vote_count (integer) - DONE

**1000_keywords.csv**
* id - Movie instance URI
* keywords - Movie: keyword (String) (transform: split) DONE

Example: 
* col1: `862`	
* col2: `[{'id': 931, 'name': 'jealousy'}, {'id': 4290, 'name': 'toy'}, {'id': 5202, 'name': 'boy'}, {'id': 6054, 'name': 'friendship'}, {'id': 9713, 'name': 'friends'}, {'id': 9823, 'name': 'rivalry'}, {'id': 165503, ':joinConditionname': 'boy next door'}, {'id': 170722, 'name': 'new toy'}, {'id': 187065, 'name': 'toy comes to life'}]`

**1000_links.csv**
* movieId
* imdbId - IMDBResource: id (String) DONE
* imdb_url -IMDBResource: url (String) DONE

Example:
`1,0114709,https://www.imdb.com/title/tt0114709,862`

**1000_movies_metadata.json**

all parent keys: ['genres', 'id', 'imdb_id', 'original_title', 'production_companies', 'production_countries', 'spoken_languages']

* genres
    * id - Genre: id (Integer) DONE
    * name - Genre: hasName (String)
* id - link to Movie instance URI - DONE
* imdb_id
* original_title  Movie: originalTitle (String) - DONE
* production_companies
    * name - FilmStudio: hasName (String) DONE
    * id - FilmStudio: id (Integer) DONE
* production_countries - Movie: hasProductionCountry (String) - DONE
* spoken_languages - Movie: hasSpokenLanguage (String) - DONE

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

['cast', 'crew', 'id']

* cast
    * cast_id  
    * character - Cast: hasCastCharacter (String) - DONE
    * credit_id - Cast: URI - DONE
    * gender - Actor: hasGender (string) transform gender: 0==unknown,1==female, 2==male - DONE(gender: unsure if it refers to character or actor) 
    * id  +  Cast: hasCastActor(Actor)
    * name - Actor: URI 
* crew
    * credit_id "52fe4284c3a36847f8024f49",
    * department  "Directing",
    * gender  - hasGenre
    * id  MovieDirector URI / Writer URI
    * job 
        * if "Director" -> MovieDirector
        * if "Writer" -> Writer
    * name
* id - use for linking from Movie instance URI

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


## Mapping with RMLmapper & YARRRML
### YARRRML

`docker pull rmlio/yarrrml-parser:latest`

yarrrml mapping file [data/movie_map.yarrr.yml](./data/movie_map.yarrr.yml)


**convert YAML to RML**

`docker run --rm -it -v $(pwd)/data:/data rmlio/yarrrml-parser:latest  -i /data/movie_map.yarrr.yml -o /data/tmp/movie_map.yarrr.ttl
` 

**map CSV to rules people.rml.ttl**

`docker run --rm -v $(pwd)/data/:/data/ rmlio/rmlmapper-java -m /data/tmp/movie_map.yarrr.ttl -s turtle -o /data/output/all.ttl`


## GraphDB
### docker: build, run

`git clone https://github.com/Ontotext-AD/graphdb-docker.git`

`mv graphdb-free-9.10.1-dist.zip free-edition`

`make free VERSION=9.10.1`

(dont think is needed) `docker pull ontotext/graphdb:9.10.1-free`

`docker build --no-cache --pull --build-arg edition=free --build-arg version=9.10.1 -t ontotext/graphdb:9.10.1-free free-edition
`

`docker run -d -p 127.0.0.1:7200:7200 --name graphdb -t ontotext/graphdb:9.10.1-free`


