## How to use this image

Start the MongoDB container
```
$ docker run --name some-mongo -d mongo
```

Start Elasticsearch
```
$ docker run --name some-elasticsearch -d elasticsearch elasticsearch -Des.cluster.name="graylog"
```

Run Graylog server and link with the other two
```
$ docker run --link some-mongo:mongo --link some-elasticsearch:elasticsearch -d graylog-server
```

### Settings

Graylog comes with a default configuration that works out of the box but you have to set a password for the admin user. Also the web interface needs to know how to connect from your browser to the Graylog API. Both can be done via environment variables.

```
  -e GRAYLOG_PASSWORD_SECRET=somepasswordpepper
  -e GRAYLOG_ROOT_PASSWORD_SHA2=8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
  -e GRAYLOG_REST_TRANSPORT_URI="http://127.0.0.1:12900"
```
In this case you can login to Graylog with the user and password `admin`.  Generate your own password with this command:

```
  $ echo -n yourpassword | shasum -a 256
```

This all can be put in a `docker-compose` file, like:

```
some-mongo:
  image: "mongo:3"
some-elasticsearch:
  image: "elasticsearch:2"
  command: "elasticsearch -Des.cluster.name='graylog'"
graylog:
  image: graylog2/server:2.0.0-rc.1-1
  environment:
    GRAYLOG_PASSWORD_SECRET: somepasswordpepper
    GRAYLOG_ROOT_PASSWORD_SHA2: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
    GRAYLOG_REST_TRANSPORT_URI: http://127.0.0.1:12900
  links:
    - some-mongo:mongo
    - some-elasticsearch:elasticsearch
  ports:
    - "9000:9000"
    - "12900:12900"
```

After starting the three containers with `docker-compose up` open your browser with the URL `http://127.0.0.1:9000` and login with `admin:admin`

## Persist log data

In order to make the log data and configuration in Graylog persistent, you can use external volumes to store all data. In case of a container restart simply re-use the existing data from former instances. Make sure that the service user can write to `/graylog`, than the complete compose file looks like this:

```
some-mongo:
  image: "mongo:3"
  volumes:
    - /graylog/data/mongo:/data/db
some-elasticsearch:
  image: "elasticsearch:2"
  command: "elasticsearch -Des.cluster.name='graylog'"
  volumes:
    - /graylog/data/elasticsearch:/usr/share/elasticsearch/data
graylog:
  image: graylog2/server:2.0.0-rc.1-1
  volumes:
    - /graylog/data/journal:/usr/share/graylog/data/journal
    - /graylog/config:/usr/share/graylog/data/config
  environment:
    GRAYLOG_PASSWORD_SECRET: somepasswordpepper
    GRAYLOG_ROOT_PASSWORD_SHA2: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
    GRAYLOG_REST_TRANSPORT_URI: http://127.0.0.1:12900

  links:
    - some-mongo:mongo
    - some-elasticsearch:elasticsearch
  ports:
    - "9000:9000"
    - "12900:12900"
```
Copy the basic configuration files from [here](https://github.com/Graylog2/graylog2-images/tree/2.0/docker/config) to `/graylog/config` on the host system. Create a unique node ID with `uuidgen > /graylog/config/node-id` and start all services with

```docker-compose up```
 
## Configuration

Every configuration option can be set via environment variables, take a look [here](https://github.com/Graylog2/graylog2-server/blob/master/misc/graylog.conf) for an overview. Simply prefix the parameter name with `GRAYLOG_` and put it all in upper case. Another option would be to store the configuration file outside of the container and edit it directly.

## Documentation

Documentation for Graylog is hosted [here](http://docs.graylog.org/en/latest/). Please read through the docs and familiarize yourself with the functionality before openeing an [issue](https://github.com/Graylog2/graylog2-server/issues) on Github.

## License

View [license information](https://github.com/Graylog2/graylog2-server/blob/master/COPYING) for the software contained in this image.
