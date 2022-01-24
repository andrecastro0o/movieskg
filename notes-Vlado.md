https://github.com/andrecastro0o/movieskg

# scripts/fix_csv.py
- "split keywords string from 1000_keywords.csv into individual keys"
  - In OR you can do that with "Cell> Split into mutiple rows"
  - In TARQL you can do it with apf:strSplit (https://tarql.github.io/#split-a-field-value-into-multiple-values)
  - Maybe the same is possible with RML functions (FNO) since these incorporate GREL functions? Not sure, since it'd need to produce multiple bindings
- "remove corrupt rows": I agree with you, some of the rows appear broken (it's not multi-line records)

# movie.ttl

- define and use the foaf: namespace 
- you can't use multiple values for dObje
  and anything with hasName to become mo:FilmStudio, mo:Genre, and mo:Movie.
  You should use owl:unionOf, or schema:domainIncludes (which we often use):
```
mo:hasActor rdfs:domain mo:Cast, mo:Movie.
mo:hasName rdfs:domain mo:FilmStudio, mo:Genre, mo:Movie.
```

`rdfs:domain` with `owl:unionOf` classes can be expressed in Protege within "Class Expression Editor" window in Manchester syntax with `:Movie or :Cast`
Resulting in 
```ttl
mo:hasActor rdf:type owl:ObjectProperty ;
            rdfs:domain [ rdf:type owl:Class ;
                          owl:unionOf ( mo:Cast
                                        mo:Movie
                                      )
                        ] ;
            rdfs:range mo:Actor .
```

Read more in [Class Expression Syntax](http://protegeproject.github.io/protege/class-expression-syntax/)

- You don't need such OWL crap. In our "optimized" rulesets such useless inferences are eliminated:
```
rdfs:subPropertyOf owl:topObjectProperty.
rdfs:subPropertyOf owl:topDataProperty
```

- This is wrong, it should point to the Crew class (which has Actor and Character)
```
mo:hasCrew rdfs:range <http://xmlns.com/foaf/0.1/Person>
```

- I don't know why Protege does this, but `owl:rational` is wrong (neither of the fields is "rational"). 
  Also, it's a totally useless datatype because it has no lexical representation!

```
mo:IMDBResource rdf:type owl:Class ;
                rdfs:subClassOf [ rdf:type owl:Restriction ;
                                  owl:onProperty mo:url ;
                                  owl:minQualifiedCardinality "1"^^xsd:nonNegativeInteger ;
                                  owl:onDataRange owl:rational
                                ] ,

                                ] ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty mo:id ;
                                  owl:qualifiedCardinality "1"^^xsd:nonNegativeInteger ;
                                  owl:onDataRange owl:rational
                                ] ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty mo:vote_average ;
                                  owl:qualifiedCardinality "1"^^xsd:nonNegativeInteger ;
                                  owl:onDataRange owl:rational
                                ] ,
                                [ rdf:type owl:Restriction ;
                                  owl:onProperty mo:vote_count ;
                                  owl:qualifiedCardinality "1"^^xsd:nonNegativeInteger ;
                                  owl:onDataRange owl:rational
                                ] .
```

Notes.md
```
**1000_movies_metadata.csv**
* adult - Movie: isAdultMovie (boolean) **Transform** - DONE
* budget - Movie: budget (integer) - DONE
```
- I also keep notes like this while doing a mapping. Good!

# movie_map.yarrr.yml

- Excellent!
- "bug! using float cause RML this value to float; converts to float: xsd:integer -> "96.0"^^xsd:integer":
  Did you report this bug?
- "BUG HERE: only one hasWriter statement is written to graph":
  Did you report this bug?
  - Same bug applies to hasWriter: neither has multiple values in the output:
```
grep -P "(hasMovieDirector|hasWriter).*," all.ttl
```

- Isn't there a way to write conditions in a shorter way? 
```
    sources:
      - [1000_credits.json~jsonpath, "$[*]"]
        o:
          v: ex:director_$(.crew[*].id)
        condition:
          function: equal
          parameters:
            - 
              - str1
              - $(.crew[*].job)
            - [str2, "Director"]
```
  - I think you can have conditions in jsonpath, something like `$[*].crew[?(@.job=="Director")]`
  - At least, you can express json arrays on the same line to reduce clutter:
```
          parameters: [[str1, $(.crew[*].job)], [str2, "Director"]]
```


# output

- All data is converted per task definition
- Instance URLs are well constructed eg `ex:actor_54768`.
- I personally would use slash not underscore since slash suggests a collection of things. (That would preclude the use of prefixed URLs but one could use BASE to shorten them)
- This better be ex:person_54768 because it's possible the same person was Actor in one movie, Director in another, and Writer in a third one, and we want those person records to mesh together.
  - A similar defect is in the task definition: it defines Actor, Director, Writer as subclasses of Person, but roles of a person.
  - (A similar defect is prevalent in DBpedia, even having non-sensical classes like Medalist and BronzeMedalist. Even I won a medal once!)

- I personally prefer real URLs eg `<http://www.starwars.com/films/star-wars-episode-iv-a-new-hope>` instead of literals (xsd:anyURI or string).
  For that, declare it as an ObjectProperty but without range.
  (You did make `mo:url` according to spec, but specs also have bugs :-)
```
mo:homepage "http://www.starwars.com/films/star-wars-episode-iv-a-new-hope"^^xsd:anyURI
mo:url "https://www.imdb.com/title/tt0120735"
```

- Usually we skip "unknown" statements because in the semantic web, you don't need to state what you don't know (some other source may know)
```
ex:actor_1000083 a mo:Actor; mo:hasGender "unknown";
```

- all datatypes are correctly assigned
- You could attach the language not just to `description` but also to `originalTitle, tagline`.
  But the JSON field `spoken_languages` is an array

# Queries

## Keyword "toy"

- 01_movie_kw_toy.rq

  - This kills performance because it can't use the literal index.
    You should trust the spelling (or normalize keywords to lowercase when converting) and use a direct pattern `mo:keyword "toy"`.
    (I asked for "toy", not substring matching of "toy")
```
?movie a mo:Movie;
           mo:keyword ?kw ;     
FILTER CONTAINS(LCASE(?kw), "toy")
```

- I've always thought FILTER is written with parentheses. Except `FILTER EXISTS, FILTER NOT EXISTS`.
  - `FILTER CONTAINS(LCASE(?kw), "toy")`: works without parentheses
  - `FILTER (?vote_count >= 100)`: doesn't work without parentheses
  - Let's check in http://rawgit2.com/VladimirAlexiev/grammar-diagrams/master/sparql11-grammar.xhtml
  - Yep, http://rawgit2.com/VladimirAlexiev/grammar-diagrams/master/sparql11-grammar.xhtml#Constraint says so
  - You can even write `FILTER ex:myBooleanFunction(?foo)` without brackets
  - I learned something new today

- 01_api_query.sh: using URL-encoded queries in a script is hateful. Curl has an option to take a file as input, and encode it as needed
- `SELECT DISTINCT`: this is an expensive operation, so always try to write queries to avoid the need to use it.
  Which basically means to avoid Cartesian Product.

- I try to write queries without unnecessary vars and therefore use `SELECT *` (and introduce vars in the same way I want them in the output).
  I also use less space and as many shortcuts as possible.
  So I'd rewrite the second query like this:

```
SELECT * {
  ?movie a mo:Movie; mo:keyword "toy" ;
    mo:hasName ?movie_name ; 
    mo:hasIMDBResource [
      mo:vote_count ?vote_count ;
      mo:vote_average ?vote_avg]
  FILTER (?vote_count >= 100)
}
ORDER BY DESC(?vote_avg)
LIMIT 10
```
