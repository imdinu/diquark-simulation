#!/bin/bash

mkdir logs

# Copy logs from all containers
for container in $(docker ps -aq); do
    docker logs $container > "logs/logs_$container.log"
done