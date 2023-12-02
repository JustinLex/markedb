#! /usr/bin/bash
set -x

echo Starting Kubernetes...
# This adds special config to containerd to tell it to use the local registry setup in d/kind_registry_create.sh
# This is required as of kind 0.20.0, but kind will eventually enable this by default and this patch will be unnecessary.
# https://github.com/kubernetes-sigs/kind/releases/tag/v0.20.0
# https://github.com/kubernetes-sigs/kind/issues/2875
cat <<EOF | kind create cluster --wait 2m --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry]
    config_path = "/etc/containerd/certs.d"
EOF

echo Starting container registry...
dev_script_dir="$(dirname $(realpath $0))"
sh -c "$dev_script_dir"/kind_registry_create.sh

echo Starting craft and Tilt dashboard...
tilt up
