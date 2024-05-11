#!/bin/bash

USERNAME=iamtaochen
# This script is used to build the docker image for the acme application
# and push it to the docker hub repository

# Login to the docker hub
docker login -u ${USERNAME}

# Build the docker image
docker build -t acme .

# Tag the docker image
docker tag acme:latest docker.io/${USERNAME}/acme:latest

# Push the docker image
docker push docker.io/${USERNAME}/acme:latest
