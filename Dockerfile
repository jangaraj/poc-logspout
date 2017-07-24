FROM golang:1.8 as build
RUN go get -d github.com/gliderlabs/logspout \
  && go get -d github.com/looplab/logspout-logstash \
  && cd /go/src/github.com/gliderlabs/logspout \
  && sed -i '/import (/a     _ "github.com/looplab/logspout-logstash"' \
  /go/src/github.com/gliderlabs/logspout/modules.go \
  && CGO_ENABLED=0 GOOS=linux go build -a -tags "netgo static_build" \
     -installsuffix netgo -ldflags "-w -s" -o logspout 
 
FROM ubuntu as cert
RUN apt-get update && apt-get install ca-certificates -y
 
FROM scratch
WORKDIR /
COPY --from=build /go/src/github.com/gliderlabs/logspout/logspout /
COPY --from=cert /etc/ssl/certs /etc/ssl/certs
 
CMD ["/logspout"]
