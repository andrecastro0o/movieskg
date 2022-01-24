#!/bin/sh
curl \
-s \
--header 'Accept: application/sparql-results+json' \
-G http://localhost:7200/repositories/movies \
--data-urlencode "query@queries/02_10ranked_toy.rq"
