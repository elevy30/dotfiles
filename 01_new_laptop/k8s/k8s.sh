#!/bin/bash

# print each command before running it
set -v
# set -x

##################################################
pushd "$(dirname "$0")" >/dev/null || exit
K8S_FOLDER=/opt/dev/dotfiles/01_new_laptop/k8s

###### HOME & USR ######
function copy_files() {
  cp -rfv ${K8S_FOLDER}/home/elevy/* ~/
  cp -rfv ${K8S_FOLDER}/usr/* /usr/

  sudo chmod +x /usr/local/bin/k3d
  sudo chmod +x /usr/local/bin/kubectl
  sudo chmod +x /usr/local/bin/kubens
}

###### HELM ######
function install_helm() {
  HELM=/usr/local/bin/helm
  if [ ! -f "$HELM" ]; then
    echo "$HELM not exist - installing HELM......."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    /opt/dev/helm/get_helm.sh
  fi
}

###### K9S ######
function install_k9s() {
  K9S=/usr/local/bin/k9s
  if [ ! -f "$K9S" ]; then
    echo "$K9S not exist - installing K9S......."
    wget https://github.com/derailed/k9s/releases/download/v0.19.4/k9s_Linux_x86_64.tar.gz
    tar xvzf k9s_Linux_x86_64.tar.gz
    rm -rf LICENSE README.md k9s_*
    sudo mv k9s /usr/local/bin/
  fi
}

###### K3S ######
function install_k3s() {
  #k3d create --enable-registry --server-arg "--no-deploy=traefik"
  kubectl create namespace local

  kubectl config get-contexts
  kubectl cluster-info
  kubectl get pods --all-namespaces
}

###### skaffold ######
function install_skaffold() {
  # curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
  # chmod +x skaffold
  # sudo mv skaffold /usr/local/bin
  echo empty
}
##################################################

addToPath() {
  if [ -d "$1" ]; then
    if [[ ":$PATH:" != *":$1:"* ]]; then
      #PATH="${PATH:+"$PATH:"}$1"
      PATH="$1${PATH:+":$PATH"}"
    fi
  fi
}