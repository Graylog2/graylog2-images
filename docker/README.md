Create a *Docker* container
==================================
This project creates a Docker container with full Graylog2 stack installed.

Requirements
------------
You need a recent `docker` version installed, have a look [here](https://docs.docker.com/installation/).
Copy the `Dockerfile` to a local folder and execute

```shell
$ docker build -t graylog2 .
$ docker run -t -p 9000:9000 -p 12201:12201 -e GRAYLOG2_PASSWORD=admin graylog2
```

This will create a container and runs Graylog2 in it.

You can also mount data and log directories to make your data persistent:

```shell
docker run -t -p 9000:9000 -p 12201:12201 -e GRAYLOG2_PASSWORD=admin -v /graylog2/data:/var/opt/graylog2/data -v /graylog2/logs:/var/log/graylog2 graylog2
```

Usage
-----
After downloading all software packages, your Graylog2 instance is ready to use.
You can reach the web interface by pointing your browser to localhost: `http://localhost:9000`

The default login is `Username: admin Password: admin`. You can change password by setting environmental variable `GRAYLOG2_PASSWORD`
