# Commands

A docker compose file defines the contents of a docker isntance

## B1 Define a docker compose

```docker
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
```

## B2 Ensure both are working

```bash
curl http://localhost:9000 && curl http://localhost:8080
```

## B3 Turn off

```bash
docker compose down
```
