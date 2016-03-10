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
