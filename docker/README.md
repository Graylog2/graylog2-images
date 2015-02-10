Graylog2 *Docker* container
==================================
This project creates a Docker container with full Graylog2 stack installed.

Requirements
------------
You need a recent `docker` version installed, take a look [here](https://docs.docker.com/installation/) for instructions.

```shell
$ docker pull graylog2/allinone
$ docker run -t -p 9000:9000 -p 12201:12201 graylog2/allinone
```

This will create a container with all Graylog2 services running.


Usage
-----
After starting the container, your Graylog2 instance is ready to use.
You can reach the web interface by pointing your browser to the IP address of your Docker host: `http://<host IP>:9000`

The default login is Username: `admin` Password: `admin`.

How to get log data in
----------------------
You can create different kind of inputs under System->Inputs. You already exposed the default GELF port 12201 so it
is a good idea to start a GELF TCP input there. Here is a [list](https://www.graylog2.org/supported-sources) of available
GELF integrations. To start another input you have to expose the right port e.g. to start a raw TCP input on port 5555
add to your docker command the `-p 5555:5555` option.
Then you can send raw text to Graylog2 like `echo 'first log message' | nc localhost 5555`

Additional options
------------------
You can configure the most important aspects of your Graylog2 instance through environment variables. In order
to set a variable add a `-e VARIABLE_NAME` option to your `docker run` command. For example to set another admin password
start your container like this:

```shell
$ docker run -t -p 9000:9000 -p 12201:12201 -e GRAYLOG2_PASSWORD=SeCuRePwD graylog2/allinone
```

| Variable Name | Configuration Option |
|---------------|----------------------|
| GRAYLOG2_PASSWORD | Set admin password |
| GRAYLOG2_TIMEZONE | Set [timezone (TZ)](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones) you are in |
| GRAYLOG2_SMTP_SERVER | Hostname/IP address of your SMTP server for sending alert mails |

SMTP_SERVER can take options for authentication, make sure to use an SSL port:
GRAYLOG2_SMTP_SERVER="mailserver.com --port=465 --user=username@mailserver.com --password=SecretPassword"

Persist data
------------
In order to persist log data and configuration settings mount the Graylog data directory outside the container:

```shell
$ docker run -t -p 9000:9000 -p 12201:12201 -v /graylog2/data:/var/opt/graylog2/data -v /graylog2/logs:/var/log/graylog2 graylog2/allinone
```

Other volumes to persist:

| Path | Description |
|------|-------------|
| /var/opt/graylog2/data | Elasticsearch for raw log data and MongoDB as configuration store |
| /var/log/graylog2 | Internal logs for all running services |
| /opt/graylog2/conf | Rendered configuration files |
| /opt/graylog2/plugin | Graylog server plugins |

Multi container setup
---------------------
The Omnibus package used for creating the container is able to split Graylog2 into several components.
This works in a Docker environment as long as your containers run on the same hardware respectively the containers
need to have direct network access between each other.
The first started container is the so called `master`, other containers can grab configuration options from here.

To setup two containers, one for the web interface and one for the server component do the following:

Start the `master` with Graylog2 server parts
```shell
$ docker run -t -p 12900:12900 -p 12201:12201 -p 4001:4001 -e GRAYLOG2_SERVER=true graylog2/allinone
```
The configuration port 4001 is now accessible through the host IP address.

Start the web interface in a second container and give the host address as `master` to fetch configuration options
```shell
$ docker run -t -p 9000:9000 -e GRAYLOG2_MASTER=<host IP address> -e GRAYLOG2_WEB=true graylog2/allinone
```

Build
-----
To build the image from scratch run

```shell
$ docker build -t graylog2 .
```
