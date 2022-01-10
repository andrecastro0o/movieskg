# GraphDB
## docker: build, run

`git clone https://github.com/Ontotext-AD/graphdb-docker.git`

`mv graphdb-free-9.10.1-dist.zip free-edition`

`make free VERSION=9.10.1`

(dont think is needed) `docker pull ontotext/graphdb:9.10.1-free`

`docker build --no-cache --pull --build-arg edition=free --build-arg version=9.10.1 -t ontotext/graphdb:9.10.1-free free-edition
`

`docker run -d -p 127.0.0.1:7200:7200 --name graphdb -t ontotext/graphdb:9.10.1-free`

## SPARQL queries

curl -G -H "Accept:application/x-trig"  -d query=CONSTRUCT+%7B%3Fs+%3Fp+%3Fo%7D+WHERE+%7B%3Fs+%3Fp+%3Fo%7D+LIMIT+10 http://localhost:7200/repositories/artists


# GraphDB 
* Tutorial https://d2s.semanticscience.org/docs/guide-graphdb/
