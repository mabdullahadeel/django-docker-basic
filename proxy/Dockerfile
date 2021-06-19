# Dockerfile specifically for 'nginx'

FROM nginxinc/nginx-unprivileged:1-alpine

# Copy the configuration file to the directory inside the Docker cotainer where nginx aspect to find this file
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./uwsgi_params /etc/nginx/wsgi_params

# Switching to the root user
USER root

# Creating required dirs for nginx
RUN mkdir -p /vol/static
RUN chmod 755 /vol/static

# Switching the user to nginx
USER nginx