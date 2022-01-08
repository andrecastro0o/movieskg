# GraphDB
## 
try:

docker pull ontotext/graphdb:9.10.1-se


## run
`git clone https://github.com/Ontotext-AD/graphdb-docker.git`

`wget https://download.ontotext.com/owlim/b4ca62fe-4b8b-11ec-a600-42843b1b6b38/graphdb-free-9.10.1-dist.zip`

`mv graphdb-free-9.10.1-dist.zip free-edition`

`wget `https://email.ontotext.com/e3t/Btc/GD+113/cGJhF04/VVnhtl3SXc6SW4lcxmM8ZzYl8V7Wb0N4CYtqsN3cFw6S3q3pBV1-WJV7CgYLJW13TfK31RF8XCVhLKNb8K-087W5B33bY7DJDYWVvdxvm2MtwxmW6B1wKp66rcTCW7r_-M87WQsx2W8pK2rc4dhsdpW2WXd8C7435qvW1N5j1m6Phv8NW7mZYkf1zmRLmW65YF5K2Zk62vW6XP1Zj4-PJ2_VRzYPp9dB284W27cT5P9ctt4jW2srRqJ6V5HvDW4dgvNr6sVtWsW2KJJxb7RXqgHN5v_FHG2JkgLW2V4BfZ5tk1QBW8Jz6882XGrnwW39gyNL8WVWlRW2B9bVm4LS6xvW70NMzr28KFl7N4yF-X0vdycnW4flcLq2VSchBW94-VLw5H_yb2VD4Bcp7r4XWpN5Wc04LsXCdGVTkrhN7lF0WQW3HMH_C9fWPpG3qk_1

`docker pull ontotext/graphdb:9.10.1-free`

`docker run -d -p 127.0.0.1:7200:7200 --name graphdb -t ontotext/graphdb:9.10.1-free`

## SPARQL queries

curl -G -H "Accept:application/x-trig"  -d query=CONSTRUCT+%7B%3Fs+%3Fp+%3Fo%7D+WHERE+%7B%3Fs+%3Fp+%3Fo%7D+LIMIT+10 http://localhost:7200/repositories/artists


# GraphDB 
* Tutorial https://d2s.semanticscience.org/docs/guide-graphdb/
