#!/bin/bash

LOG_DIR="CMS_logs_130_80_semilepto"

mkdir $LOG_DIR

# Copy logs from all containers
for container in $(docker ps -aq); do
    CONTAINER_NAME=$(docker ps -a --filter "id=$container" | tail -n +2 | awk '{print $12}')
    docker logs $container > "$LOG_DIR/logs_$CONTAINER_NAME.log"
done