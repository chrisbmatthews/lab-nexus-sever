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

### First login
Click 'Sign In'.

You will sign in using the `admin` username.

You can find the initial admin password by running:

```
cat volume/admin.password
```

On first login, you will be prompted to change the admin password.

If you like, you can enable anonymous access.

## Docker Repo
### Docker Hub Proxy
To set up a proxy to Docker Hub:

**For the blob storage**
- Click the config (gear) icon.
- Navigate to 'Blob Stores'.
- Create a new Blob Store of type File.  
    - You can name it whatever you like, but a good choice is `docker-hub`.
- Click 'Create Blob Store'.

**For the Security Realm**
- Click Security > Realms
- Add the 'Docker Bearer Token Realm'
- Click 'Save'

**For the repo itself**
- Click 'Repositories'
- Click 'Create Repository' and select 'docker (proxy)'
- Give it some name (`docker-hub-proxy`)
- Check 'HTTP' and give it a valid port (`8082`)
- Check 'Allow anonymous docker pull'
- Under Proxy > Remote Storage, enter this url: `https://registry-1.docker.io`
- Under Docker Index, select 'Use Docker Hub'
- Under Storage > Blob Store, select the blob store you created earlier (`docker-hub`)
- Click 'Create Repository'

#### Docker configuration
For Docker Desktop (Windows or macOS), open your Docker Preferences, and select 'Docker Engine'.

Add this section:
```
  "insecure-registries": [
    "localhost:8082"
  ],
```

Apply & Restart

#### Pulling Through the Proxy
You can now pull images via your repository.  If the image you want is not in your local repo, it'll be pulled from docker hub and cached into your repo for the default amount of time (24 hours) before being re-checked.

An example pull:

```
docker pull localhost:8082/ubuntu
```

### Private Docker Repository
**For the blob storage**
- Click the config (gear) icon.
- Navigate to 'Blob Stores'.
- Create a new Blob Store of type File.  
    - You can name it whatever you like, but a good choice is `docker-private`.
- Click 'Create Blob Store'.

**For the repo itself**
- Click 'Repositories'
- Click 'Create Repository' and select 'docker (hosted)'
- Give it some name (`docker-private`)
- Check 'HTTP' and give it a valid port (`8083`)
- Under Docker Index, select 'Use Docker Hub'
- Under Storage > Blob Store, select the blob store you created earlier (`docker-private`)
- Click 'Create Repository'

**Docker Config**

Make sure you add the new url and port to the `insecure-registries` section of the docker config.

Eg:

```
  "insecure-registries": [
    "localhost:8082",
    "localhost:8083"
  ],
```

#### Docker Login
To connect to the repository, you will need to login using the docker cli:

```
docker login localhost:8083
```

You can then provide user credentials (eg. - the admin user will work).

#### Tagging private images
When you build a docker impage you'd like to push to the private registry, be sure to prefix the image name with the registry url.

Example:

```
docker build -t localhost:8083/myimage:latest .
```

Once it has been built, you can push it to the registry:

```
docker push localhost:8083/myimage:latest
```