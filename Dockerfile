FROM nginx:1.23

RUN mkdir /etc/nginx/templates

COPY default.conf.template /etc/nginx/templates

# --- Target Config ---
ENV TARGET_HOST="localhost"
ENV TARGET_PORT=80

# --- Performance & Behavior ---
ENV PROXY_TIMEOUT="60s"
ENV PROXY_BUFFERING="on"
ENV CLIENT_MAX_BODY_SIZE="1m"

# --- Advanced Features ---
# 1. Large Headers: Increase if getting 431 errors (e.g. "4 16k")
ENV LARGE_CLIENT_HEADER_BUFFERS="4 8k"

# 2. Video/Audio: Set to "on" to force byte-range support for seeking
ENV PROXY_FORCE_RANGES="off"