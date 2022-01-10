#!/bin/sh

# preprocess 1000_keywords.csv to data/fixed_1000_keywords.csv
python3 scripts/split_keywords.py

# convert mapping from yaml to ttl
docker run --rm -it -v $(pwd)/data:/data rmlio/yarrrml-parser:latest  -i /data/movie_map.yarrr.yml -o /data/tmp/movie_map.yarrr.ttl
# map
docker run --rm -v $(pwd)/data/:/data/ rmlio/rmlmapper-java -m /data/tmp/movie_map.yarrr.ttl -s turtle -o /data/output/all.ttl

# garbage collection
rm data/fixed_1000_keywords.csv
