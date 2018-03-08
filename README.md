# What is Matomo?

Matomo is an open-source web analytics platform, providing detailed reports of web traffic.

> [http://mattomo.org/](http://matomo.org/)

# Usage

    docker run \
      --name matamo \
      --link some-mysql:mysql \
      -p 80:80 \
      -v $(pwd)/config:/var/www/html/config/:rw \
      benhutchins/matomo

## Database

The example above uses `--link` to connect the Matomo container with a running [mysql](https://hub.docker.com/_/mysql/) container. To start a mysql container simply run:

    docker run \
      --name some-mysql \
      -e MYSQL_ROOT_PASSWORD=password \
      -e MYSQL_DATABASE=matomo \
      -e MYSQL_USER=matomo \
      -e MYSQL_PASSWORD=password \
      mysql

You'll want to configure the database name, user and password whcih will be used as part of the Matomo installation process.

## Docker Compose

To run with [Docker Compose](https://docs.docker.com/compose/install/), copy the `docker-compose.yml` from this repository and run:

    docker-compose up
