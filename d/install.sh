#! /usr/bin/bash
set -x

echo This script only works on Linux and MacOS.

echo Assuming Docker is installed and running.

echo Installing Tilt
# https://docs.tilt.dev/
curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

echo Installing kubectl
# https://kubernetes.io/docs/tasks/tools/
if [[ "$OSTYPE" == "darwin"* ]]; then
  # MacOS
  if [[ $(uname -m) == 'arm64' ]]; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
  else
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
  fi
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  sudo chown root: /usr/local/bin/kubectl
else
  # Linux amd64
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
fi

echo Installing Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo Installing Kind
# https://kind.sigs.k8s.io/docs/user/quick-start
if [[ "$OSTYPE" == "darwin"* ]]; then
  # MacOS
  brew install kind
else
  # Linux amd64/arm64
  [ "$(uname -m)" = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
  [ "$(uname -m)" = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
fi
