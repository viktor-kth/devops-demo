# Docker CLI

The most direct way to run and manage containers on a virtual machine, VM, is through Docker CLI. This approach is what we call *imperative*, we explicitly tell docker what to do.

Doing this imperatively is quick and a good way to get started and to experiment, but as we will notice, this method does also run the risk och becoming error-prone and tedious. This because we need to manually maintain and update the containers one by one whenever we need to change anything.

Lets walk through how we setup and run the simple two-service setup with a backend API and a frontend webserver.

## A1 Define a local Docker network

First and formost however, we need to define a network. By default, containers are isolated and therefore unable to communicate, to solve this we will need to run and define the following:

```bash
docker network create iac-net || true
```

This ensurs that the backend and frontend are able to reach eachother.

## A2 Start the Backend

Next we will start a simple HTTP echo server from HashiCorp. This server will just respond with a JSON string when prompted:

```bash
docker run -d --name api --network iac-net -p 9000:5678 \
  hashicorp/http-echo:0.2.3 \
  -listen=:5678 -text='{"service":"api","status":"ok"}'
```

The parameters used in the command are the following,

- `--name api`: gives the container the name `api`, so that we easily can track the resource
- `--network iac-net`: attaches the api to the network we created
- `--p 9000:5678`: maps the port 9000 on the host to port 5678 in the container
- The rest defines the server image (aka predefined docker resource) we will be using as well as both matching the internal port to be listening on port 5678 and the response upon a request.

## A3 Start the frontend

For the frontend we will use Nginx to manage requests to the actual webserver program. We will then mount a local directory with a static site file and a config file in the container.

```bash
docker run -d --name web --network iac-net -p 8080:80 \
  -v "$PWD/site:/usr/share/nginx/html:ro" \
  -v "$PWD/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable
```

- `-v $PWD/site:/usr/share/nginx/html:ro"`: maps our local site file to the static site folder in nginx.
- `-v "$PWD/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro"`: maps the config file to nginx, this is the file which defines which port should be used as well as what should be servered ones a request is sent to the endpoint.
- `-p 8080:80`: makes the site available locally on `http://localhost:8080`.

## A4 Ensure both are working

Now we can check that both are running correctly:

```bash
curl http://localhost:9000 && curl http://localhost:8080
```

Running this we should see `{"service":"api","status":"ok"}` followed by some HTML code. If you want more information about Nginx how it works you can open the link that you should see in the `&lt;a&gt;` tag in the response.

## A5 The Pain of Change

Thus far everything has been smooth sailing, nothing too complicated and everything has been very quick. Here is where the imperative approach starts to show its impracticality.

Now lets say something happens and someone accidentally removes one of the parts from the server, like the frontend:

``` bash
docker rm -f web
```

Now the frontend is unreachable and you would have to manually create it again,

Recreating the frontend over and over would become very cumbersome, because then we have to re-define everything from the terimal also this process quickly becomes:

- Error prone, easy to forget the flags used.
- Hard to share, as you need to share the exact sequence of commands in the exact order.
- Painful to scale, you need to copy and paste with different ports and configurations.

Now lets just clean this up before we move on to a better solution:

```bash
docker rm -f web api iac-net
```

