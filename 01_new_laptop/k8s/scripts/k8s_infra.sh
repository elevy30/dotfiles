#!/bin/bash
K8S_FOLDER=$(pwd)
source "${K8S_FOLDER}/scripts/util.sh"

#####################
###### KUBECTL ######
#####################
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
function install_kubectl() {
  KUBECTL=/usr/local/bin/kubectl
  if [ ! -f "$KUBECTL" ]; then
    echo "---> $KUBECTL not exist - installing KUBECTL ..."
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
  else
    echo "vvv $KUBECTL already installed vvv"
  fi

  if ! grep -rnw "/home/elevy/.zshrc" -e "kubectl completion zsh" ; then
    echo "---> Update ~/.zshrc file with kubectl ..."
    {
      echo 'source <(kubectl completion zsh)'
      echo 'alias k=kubectl'
      echo 'complete -F __start_kubectl k'
    } >> /home/elevy/.zshrc
  else
    echo "vvv ZSH is updated with kubectl context and alias"
  fi

  echo "---------------> kubectl version --client <---------------"
  kubectl version --client
  echo "---------------> kubectl cluster-info <---------------"
  kubectl cluster-info
  echo "---------------> kubectl config get-contexts <---------------"
  kubectl config get-contexts
  echo "---------------> kubectl get nodes <---------------"
  kubectl get nodes
  echo "---------------> kubectl get namespaces <---------------"
  kubectl get  namespaces
  echo "---------------> kubectl get pods --all-namespaces <---------------"
  kubectl get pods --all-namespaces
}

#################
###### K9S ######
#################
function install_k9s() {
  K9S=/usr/local/bin/k9s
  if [ ! -f "$K9S" ]; then
    echo "$K9S not exist - installing K9S......."
    wget https://github.com/derailed/k9s/releases/download/v0.19.4/k9s_Linux_x86_64.tar.gz
    tar xvzf k9s_Linux_x86_64.tar.gz
    rm -rf LICENSE README.md k9s_*
    sudo mv k9s /usr/local/bin/

    sudo cp -rfv "${K8S_FOLDER}/home/elevy/.k9s" ~/
  fi
}

##################
###### HELM ######
##################
function install_helm() {
  HELM=/usr/local/bin/helm
  if [ ! -f "$HELM" ]; then
    echo "$HELM not exist - installing HELM......."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
  fi
}

######################
###### skaffold ######
######################
function install_skaffold() {
  # curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
  # chmod +x skaffold
  # sudo mv skaffold /usr/local/bin
  echo " ----- not implemented ----- "
}



