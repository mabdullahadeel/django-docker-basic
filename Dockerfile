# Inheriting the base python version
FROM python:3.8-alpine

# Adding script to the path of the running container
ENV PATH="/script:${PATH}"

# Installing packages that are required in order to install the WSGI server
# - Breakdown
# apk -> Application package manager for alpine
# add -> similar to install on ubuntu (alpine package manager)
# --update -> updaing the package repository (similar to --> sudo apt update)
# --no-cache -> Prevent caching
# --virtual .tmp -> temporary dependencies that might be removed furhter down the Dockerfile
# Dependecies being installed --> gcc, lib-dev, linux-headers (require to install 'requirements.txt')
RUN apk add --update --no-cache --virtual .tmp gcc lib-dev linux-headers

# Installing dependencies using 'pip'
RUN pip install -r /requirements.txt

# Removing the .temp dependecies as they are not required and project dependencies have been installed
RUN apk del .tmp

# Creating the new app dir
RUN mkdir /app

# Copying django project into the container
COPY ./app /app

# Changing DIR
WORKDIR /app

# Creating scripts
COPY ./scripts /scripts

# Changing the permission to allow scripts to execute
RUN chmod +x /scripts/&

# Creating static assest directoris
## -p means create all the sub-direcotries as well (ie: create 'vol' and 'web' dir before 'media')
### BREAKDOWN -> Django server will save all the user uploaded images to '/vol/web/media' and nginx proxy will serve them from this dir
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# Create new linux user to run the docker app
RUN adduser -D user

# Setting the owner of the 'vol' dir to the new user
RUN chown -R user:user /vol

# Only 'user' can modify the files in '/vol/web'. All other users only have read access
RUN chmod -R 755 /vol/web

# Switching the user
USER user

# Running the script that will start the app
CMD [ "entrypoint.sh" ]