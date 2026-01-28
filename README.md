# docker-nginx-envproxy

## Overview
quick'n'easy, environment variable configurable nginx reverse proxy to swiss-army knife your way to greatness!

should handle everything from basic REST APIs to streaming LLMs, WebSockets, and seekable video content.

good luck, have fun.

## Environment Variables
- `TARGET_HOST`: Target service hostname or IP (default: `localhost`).
- `TARGET_PORT`: Target service port (default: `80`).

## Quick Start

```bash
# Basic proxy
docker run -e TARGET_HOST=api.example.com -e TARGET_PORT=443 your-proxy

# With custom timeout
docker run -e TARGET_HOST=slow-api.com -e PROXY_TIMEOUT=120s your-proxy
```

## Service Types & Use Cases

### Basic

Standard web sites, REST APIs, microservices, or simple web applications.

```bash
docker run \
  -e TARGET_HOST=api.myservice.com \
  -e TARGET_PORT=80 \
  your-proxy
```

**Default settings work great:**
- Standard timeouts (60s)
- Normal buffering for performance
- Basic header limits

### WebSocket Applications

Real-time chat, gaming, or live data feeds.

```bash
docker run \
  -e TARGET_HOST=websocket-server.local \
  -e TARGET_PORT=3000 \
  -e PROXY_TIMEOUT=3600s \
  -e PROXY_BUFFERING=off \
  your-proxy
```

**Why these settings:**
- `PROXY_TIMEOUT=3600s` - Keep connections alive for 1 hour
- `PROXY_BUFFERING=off` - Real-time message delivery
- WebSocket upgrade headers handled automatically

### Video/Audio Streaming

Enables seekable video players with proper byte-range support. Works great for RTMP streams, HLS, or direct video serving.

```bash
# For RTMP streaming server (like nginx-rtmp), should work on HLS too
docker run \
  -e TARGET_HOST=rtmp-server.local \
  -e TARGET_PORT=1935 \
  -e PROXY_FORCE_RANGES=on \
  -e CLIENT_MAX_BODY_SIZE=10G \
  -e PROXY_TIMEOUT=120s \
  your-proxy
```

**Why these settings:**
- `PROXY_FORCE_RANGES=on` - Essential for video seeking/scrubbing
- `CLIENT_MAX_BODY_SIZE=10G` - Handle large video uploads
- Extended timeout for large file transfers

### Enterprise Applications (Large Auth Tokens)

Apps with huge JWT tokens, complex cookies, or enterprise SSO.

```bash
docker run \
  -e TARGET_HOST=enterprise-app.corp \
  -e TARGET_PORT=8443 \
  -e LARGE_CLIENT_HEADER_BUFFERS="8 32k" \
  -e PROXY_TIMEOUT=90s \
  your-proxy
```

**Why these settings:**
- `LARGE_CLIENT_HEADER_BUFFERS="8 32k"` - Prevents 431 header too large errors
- Handles Azure AD, SAML, or other enterprise auth tokens

### LLM APIs (Streaming Responses)

Perfect for Ollama, local LLM servers, or any API that streams token-by-token responses.

```bash
docker run \
  -e TARGET_HOST=ollama.local \
  -e TARGET_PORT=11434 \
  -e PROXY_BUFFERING=off \
  -e PROXY_TIMEOUT=300s \
  -e CLIENT_MAX_BODY_SIZE=10m \
  your-proxy
```

**Why these settings:**
- `PROXY_BUFFERING=off` - Stream tokens immediately, don't wait for full response
- `PROXY_TIMEOUT=300s` - Long timeout for slow LLM generation
- `CLIENT_MAX_BODY_SIZE=10m` - Handle large prompts/context

### Docker Container Communication

Use container IPs or Docker's built-in service discovery (no DNS resolver needed).

```bash
# Using container IP (most reliable)
docker run \
  -e TARGET_HOST=172.17.0.2 \
  -e TARGET_PORT=8080 \
  your-proxy

# Using Docker Compose service names (Docker handles DNS internally)
docker-compose up
```

**Why no DNS resolver:**
- Container IPs are stable within the same Docker network
- Docker Compose handles service name resolution automatically
- Avoids DNS configuration issues and timeouts

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TARGET_HOST` | `localhost` | Backend hostname or IP |
| `TARGET_PORT` | `80` | Backend port |
| `PROXY_TIMEOUT` | `60s` | Connection timeout |
| `PROXY_BUFFERING` | `on` | Enable/disable response buffering |
| `CLIENT_MAX_BODY_SIZE` | `1m` | Maximum request body size |
| `LARGE_CLIENT_HEADER_BUFFERS` | `4 8k` | Buffer size for large headers |
| `PROXY_FORCE_RANGES` | `off` | Force byte-range support for media |

## Simple & Reliable

This proxy keeps it simple - no DNS resolvers, no complex networking. Just point it at an IP and port, and it works.

```bash
# Find your container IP
docker inspect backend-container | grep IPAddress

# Use the IP directly
docker run -e TARGET_HOST=172.17.0.2 -e TARGET_PORT=8080 your-proxy
```

## Troubleshooting

| Error | Solution |
|-------|----------|
| `431 Request Header Fields Too Large` | Increase `LARGE_CLIENT_HEADER_BUFFERS` |
| Video seeking doesn't work | Set `PROXY_FORCE_RANGES=on` |
| Streaming responses buffer | Set `PROXY_BUFFERING=off` |
| WebSocket connections drop | Increase `PROXY_TIMEOUT` |
| Connection refused | Check `TARGET_HOST` IP and `TARGET_PORT` |

### TODO

* evaluate / re-evaluate use of feature_flags, esp related to DNS resovler configs
