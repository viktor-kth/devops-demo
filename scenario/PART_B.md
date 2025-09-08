# Docker Compose

Lets introduce Docker Compose. With this tool you *declare* the app in YAML. Instead of manually typing the `docker run` command, you define the desired state (services, ports, volums, networks). Then using `docker compose up -d` you tell docker to create or reconclie containers to match the defined state. This makes the process reproducible and easily shareable and allows changes to be **much** more clear and easier.

## B1 Define a docker compose

The following code is an example which when we run it, will reproduce the ressult we got in the previous section. The file has to be named `docker-compose.yml` inorder to work. The file defines the resources we want to use as well as how we reach them:

`docker-compose.yml`

```yml
version: "3.8"

services:
  api:
    image: hashicorp/http-echo:0.2.3
    command: ["-listen=:5678", "-text={\"service\":\"api\",\"status\":\"ok\"}"]
    ports:
      - "9000:5678"
    networks: [app]
    restart: unless-stopped

  web:
    image: nginx:stable
    ports:
      - "8080:80"
    volumes:
      - ./site:/usr/share/nginx/html:ro
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    networks: [app]
    restart: unless-stopped

networks:
  app:
     name: docker-iac-net
```

Here are some explanations some of the new keywords,

- `services`: defines the resources we want to create
- `web` and `api`: are the names of the frontend and backend, these we could change to anything we´d like based on our needs.
- `image`: defines the docker resource we want to used
- `command`: this defins the commands which will be run upon initialzation of the container.
- `volumes`: these are the files we want to copy over to the container and where we want to put them, this could either be specific files or entire folders.
- `networks`: this defines the local network over which our front-end and back-end can communicate

As you might be able to tell a lot of the information is the exact same as in the previous step, but just defined in the file.

This file is present in the file system and by running:

```bash
docker compose up -d
```

You should automatically deploy it. If it fails and claims that the names or ports are already in use, then you forgot to clean them up from the previous step. To do this run:

```bash
docker rm -f web api
```

## B2 Ensure both are working

Now test that the endpoints are running

```bash
curl http://localhost:9000 && curl http://localhost:8080
```

## B3 Turn off

Now to turn this off we need to run the following,

```bash
docker compose down
```

We also need to make sure to stop the network, do this by running:

```bash
docker rm -f iac-net
```

## B4 The problem with Scaling even further

Now this gets us a fair bit, we are able to run multiple services from the same machine using a declarative system.

But what happens when we need:

- To define multiple different containers across **different machines**?
- **Different enviroments** (dev, stagning, production) that need to stay in sync.
- Infrastructure is more than just containers, it also includes networks, load balancers, firewalls, DNS and storage.

With Compose, we would need to juggle multiple YAML files, need to move into the correct servers and start them one by one. This would almost be like going back to square one.

This is where the concept if *Infrasctucture as Code*(IaC) comes in. IaC means that we declarativly define not only the state of the machines themselves but the entire infrastructure. A tool we can use to achive this we can use something like Terraform.

Let's move on to the next section to look at what Terraform is.
