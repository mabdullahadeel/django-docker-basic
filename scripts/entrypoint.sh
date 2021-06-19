#!/bin/sh

# If there is error, just leave the script
set -e

# collecting all the static files
python manage.py collectstatic --noinput

# Firing the wsgi app with path to django wsgi file 'app/wsgi.py'
# BREAKDOWN
## --socket -> serve as tcp socket
## :8000 -> run app on port 8000
## run this as the master service/master task
## --enable-threads -> enable multi-threading
## --module -> path to `wsgi.py` file which is by default provided by the django
uwsgi --socket :8000 --master --enable-threads --module app.wsgi