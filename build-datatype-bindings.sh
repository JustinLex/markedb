#!/usr/bin/sh

# Script for building the backend datatype bindings locally.
# This script is run automatically by Tilt/Github-Actions.

set -eux

# Build bindings in a docker container
docker build -f datatype-bindings-builder.Dockerfile . -t markedb-bindings

# Copy the built bindings from image to local directory, using the current user's uid/gid
docker run --rm \
  --user "$(id -u)":"$(id -g)"\
  -v "$(pwd)/frontend":/frontend markedb-bindings\
  cp -r /app/bindings /frontend/app/bindings
