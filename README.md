# What is Piwik?

Piwik is an open-source web analytics platform, providing detailed reports of web traffic.

> [http://piwik.org/](http://piwik.org/)

# Usage

    docker run \
      --name piwik \
      --link some-mysql:mysql \
      -p 80:80 \
      -v $(pwd)/config:/var/www/html/config/:rw \
      benhutchins/piwik

## Database

The example above uses `--link` to connect the Piwik container with a running [mysql](https://hub.docker.com/_/mysql/) container. To start a mysql container simply run:

    docker run \
      --name some-mysql \
      -e MYSQL_ROOT_PASSWORD=password \
      -e MYSQL_DATABASE=piwik \
      -e MYSQL_USER=piwik \
      -e MYSQL_PASSWORD=password \
      mysql

You'll want to configure the database name, user and password whcih will be used as part of the Piwik installation process.

## Docker Compose

To run with [Docker Compose](https://docs.docker.com/compose/install/), copy the `docker-compose.yml` from this repository and run:

    docker-compose up
