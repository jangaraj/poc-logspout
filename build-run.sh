docker build -t logspout .
docker rm -f logspout | true
docker run -d \
  --name logspout \
  --volume=/var/run/docker.sock:/var/run/docker.sock \
  --net=host \
  -e ROUTE_URIS=logstash+tcp://localhost:5000 \
  logspout
