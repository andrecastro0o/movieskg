#!/bin/sh
curl \
-s \
--header 'Accept: application/sparql-results+json' \
-G http://localhost:7200/repositories/movies \
--data-urlencode "query@queries/01_movie_kw_toy.rq"

# -G = get

# See Swagger Documentation  in http://localhost:7200/webapi
## possible headers:
### --header 'Accept: application/sparql-results+json'
### --header 'Accept: application/sparql-results+xml'
### Accept: application/x-binary-rdf-results-table' > requeires --output

# can also be done using apache jena rsparl cmdline tool
#rsparql --service=http://localhost:7200/repositories/movies --query=01_movie_kw_toy.rq 

# json output can be pipped to jq
# ./queries/01_api_query.sh | jq '.[].bindings[0]'
