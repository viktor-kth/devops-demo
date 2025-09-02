# Commands

Lets say we want to build a simple backend-frontend service,
To do this using docker we would do the following,

## A1 Define a local docker network for the containers

```bash
docker network create iac-net || true
```

## A2 Start the Backend

```bash
docker run -d --name api --network iac-net -p 9000:5678 \
  hashicorp/http-echo:0.2.3 \
  -listen=:5678 -text='{"service":"api","status":"ok"}'
```

## A3 Start the frontend

```bash
docker run -d --name web --network iac-net -p 8080:80 \
  -v "$PWD/site:/usr/share/nginx/html:ro" \
  -v "$PWD/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable
```

## A4 Ensure both are working

```bash
curl http://localhost:9000 && curl http://localhost:8080
```

## A5 Change

Now lets say something happens and someone accidentally removes one of the parts from the server, like we frontend,

``` bash
docker rm -f web
```

Now having to solve and recreating the frontend would become very cumbersome, because then we have to  re-define everything from the terimal and we could have to do this manually for every change which would eat up way too much time, thankfully docker has solved this issue of manually redoing it by defining a docker compose.

Lets move on to the next step to see how we would do this

Clean up:

```bash
docker rm -f web api
docker network rm iac-net
```
