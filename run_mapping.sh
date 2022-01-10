#!/bin/sh

# convert mapping from yaml to ttl
docker run --rm -it -v $(pwd)/data:/data rmlio/yarrrml-parser:latest  -i /data/movie_map.yarrr.yml -o /data/tmp/movie_map.yarrr.ttl
# map
docker run --rm -v $(pwd)/data/:/data/ rmlio/rmlmapper-java -m /data/tmp/movie_map.yarrr.ttl -s turtle -o /data/output/all.ttl

# # convert mapping from yaml to ttl
# docker run --rm -it -v $(pwd)/data:/data rmlio/yarrrml-parser:latest  -i /data/test_map.yarrr.yml -o /data/tmp/test_map.yarrr.ttl

# # map
# docker run --rm -v $(pwd)/data/:/data/ rmlio/rmlmapper-java -m /data/tmp/test_map.yarrr.ttl -s turtle -o /data/output/test.ttl