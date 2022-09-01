# top-example-db

This repository contains a simple database schema and example subject data. You can use the provided docker-compose configuration to create a [PostgreSQL](https://hub.docker.com/_/postgres) container and optionally an [Adminer](https://hub.docker.com/_/adminer/) container.

The database is used as a simple example setup to test to TOP Framework.

## Usage

Follow these instructions to set up the example database:

1. Clone this repository

        git clone https://github.com/Onto-Med/top-example-db.git
        cd top-example-db

2. Copy [docker-compose.env.tpl](docker-compose.env.tpl) and modify it as needed

        cp docker-compose.env.tpl docker-compose.env

3. Start the containers (you can leave out `--profile adminer` to just start the database)

        docker compose --profile adminer up -d
