# docker-nginx-envproxy

## Overview
nginx reverse proxy with configurable target host and port using environment variables.

## Environment Variables
- `TARGET_HOST`: Target service hostname or IP (default: `localhost`).
- `TARGET_PORT`: Target service port (default: `80`).

## Usage
run the container directly:
```bash
docker run -d -p 80:80 --env TARGET_HOST=<your-target-host> --env TARGET_PORT=<your-target-port> ghcr.io/dancemore/dancemore/docker-nginx-envproxy:latest
```

you can also `docker-compose` it easily.

good luck, have fun.
