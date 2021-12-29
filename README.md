# Setting up a Nexus3 Lab Server
This repo shows how to set up a nexus server for use in your home lab.

See the youtube video here:

## Installation
This repo assumes you have docker and docker-compose installed.

You can run this using the `run.sh` convenience script:

```
./run.sh
```

...this script changes permissions on the `volume` subdirectory.  This seems only to be required on Linux docker hosts.

Alternaively, you can run it via `docker-compose` directly:

```
docker-compose up -d
```

You can watch the logs as nexus comes up:

```
docker logs -f lab-nexus-sever_nexus_1
```

You are waiting to see:

```
-------------------------------------------------

Started Sonatype Nexus OSS 3.19.1-01

-------------------------------------------------
```

(or whatever version is running)

Once it's running, visit:

http://localhost:8081

