#!/usr/bin/env bash

#To allow full file access to the volume in case docker is running as root...
chmod 777 volume

#Bring up the server
docker-compose up -d