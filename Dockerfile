FROM nginx:1.23

COPY envproxy.conf.template /etc/nginx/templates

ENV TARGET_HOST="localhost"
ENV TARGET_PORT=80
