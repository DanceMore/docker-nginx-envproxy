FROM nginx:1.23

RUN mkdir /etc/nginx/templates

COPY default.conf.template /etc/nginx/templates

ENV TARGET_HOST="localhost"
ENV TARGET_PORT=80
