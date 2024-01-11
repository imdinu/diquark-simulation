# Diquark Simulation

Simulations for the vectorlike quark search and its background processes

## Requirements
Setting up the project locally requires:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [make](https://www.gnu.org/software/make/)

## Setup
1. Clone the repository
```bash
$ git clone https://github.com/imdinu/diquark-simulation.git
```
2. Get the data
```bash
$ make pull
```

## Usage
Use the [docker-compose.yml](./docker-compose.yml) file to configure the simulations and then run the following command to start the simulations
```bash
$ docker compose up
```