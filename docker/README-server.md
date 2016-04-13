How to use this image
---------------------

Start the MongoDB container

```
$ docker run --name some-mongo -d mongo
```

Start Elasticsearch

```
$ docker run --name some-elasticsearch -d elasticsearch elasticsearch -Des.cluster.name="graylog"
```

Run Graylog server

```
$ docker run --link some-mongo:mongo --link some-elasticsearch:elasticsearch -d graylog-server
```


graylog-mongo.sh:
#!/bin/sh
docker run -t \
        --name graylog-mongo            \
        -v /graylog2/data/mongo:/data/db  \
        mongo

graylog-es.sh:
#!/bin/sh
docker run -t   \
        --name graylog-es               \
        -v /graylog2/data/elasticsearch:/usr/share/elasticsearch/data   \
        elasticsearch:2.3               \ 
        -Des.cluster.name="graylog"

graylog2docker.sh
#!/bin/sh
docker run -t \
        -p 9000:9000            \
        -p 9200:9200            \
        -p 12900:12900          \
        -p 1514:1514/udp        \
        -p 12201:12201          \
        -e GRAYLOG_REST_TRANSPORT_URI="http://<host outside IP>:12900"  \
        -e GRAYLOG_ROOT_PASSWORD_SHA2=<redacted>  \
        -e GRAYLOG_TIMEZONE=EST5EDT     \
        --link graylog-mongo:mongo      \
        --link graylog-es:elasticsearch \
        graylog2/server:2.0.0-beta.3-1
