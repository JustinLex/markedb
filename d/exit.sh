#! /usr/bin/bash
set -x

kind delete cluster

docker kill kind-registry
docker rm kind-registry
