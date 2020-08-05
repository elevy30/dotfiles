#!/bin/bash

DOCKER_VERSION=5:19.03.12~3-0~ubuntu-focal
PASSWORD=elevy

function pause(){
  echo "$1"
  echo -n "Press any key to resume ..."
  read -r action
}

####################
###### DOCKER ######
####################
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

###### Docker - REMOVE  ######
function remove_docker() {
  echo "Removing old docker packages ..."
  sudo -S apt-get remove docker
  sudo -S apt-get remove docker-engine
  sudo -S apt-get remove docker.io
  sudo -S apt-get remove containerd
  sudo -S apt-get remove runc
}

###### Docker Repository ######
function add_docker_repository() {
  echo "Adding  docker repository ..."
  # Update the apt package index
  sudo apt-get --assume-yes update
  # Install packages to allow apt to use a repository over HTTPS:
  sudo apt-get --assume-yes install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  # Add Docker’s official GPG key:
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  # Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88,
  # by searching for the last 8 characters of the fingerprint.
  sudo apt-key fingerprint 0EBFCD88
  pause "Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
}

###### Docker Engine ######
function install_docker() {
  if [ "$(systemctl is-active docker)" == "active" ]; then
    echo "vvv Docker version $(docker version --format '{{.Server.Version}}') was installed vvv"
  else
    echo "---> Installing Docker version ${DOCKER_VERSION} ..."

    sudo apt-get --assume-yes update
    # Install a specific version using the version string from the second column, for example, 5:18.09.1~3-0~ubuntu-xenial
    # apt-cache madison docker-ce (for getting teh version available)
    sudo apt-get --assume-yes install docker-ce="${DOCKER_VERSION}" docker-ce-cli="${DOCKER_VERSION}" containerd.io

    # Verify that Docker Engine is installed correctly by running the hello-world image.
    pause "Verify that Docker Engine is installed correctly by running the hello-world image."
    sudo docker run hello-world

    # Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/containers/json: dial unix /var/run/docker.sock: connect: permission denied
    # https://www.digitalocean.com/community/questions/how-to-fix-docker-got-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket
    sudo groupadd docker
    echo $PASSWORD | sudo -S usermod -aG docker "${USER}"
    # su -s "${USER}"
    # sudo systemctl restart docker
    sudo chmod 666 /var/run/docker.sock

    #### - add this line to .zshrc/.profile
    # export DOCKER_HOST=tcp://localhost:2375
  fi
}

###### Docker Local Registry ######
function create_docker_local_registry(){
  if [ -z "$(docker ps -q -f name=registry)" ]; then
    echo "---> Creating Docker local registry ..."
    docker volume create local_registry
    docker container run -d --name registry.local -v local_registry:/var/lib/registry --restart always -p 5000:5000 registry:2
  else
    echo "vvv Docker local registry already created vvv"
  fi

  if ! grep -rnw "/etc/hosts" -e "127.0.0.1 registry.local" ; then
    echo "---> Update /etc/hosts file with registry.local ..."
    ### add registry to /etc/hosts
    sudo chmod 777  /etc/hosts
    sudo echo 127.0.0.1 registry.local >> /etc/hosts
  fi
}


#####################
###### KUBECTL ######
#####################
# https://kubernetes.io/docs/tasks/tools/install-kubectl/

###### kubectl ######
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
###### K3D ######
#################
# https://k3d.io/usage/commands/
###### k3d image ######
function install_k3d() {
  K3S=/usr/local/bin/k3d
  if [ ! -f "$K3S" ]; then
    echo "---> $K3S not exist - installing K3S ..."
    sudo wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v3.0.0 bash
  else
    echo "vvv $K3S already installed vvv"
  fi

  k3d version
}

###### k3d create cluster ######
function create_k3d_cluster() {
  k3s_container="$(docker ps --format 'table {{.Names}}' | grep k3d)"
  if [ -z "${k3s_container}" ]; 	then
	  echo "---> K3D cluster not exist - Creating new  K3S cluster ..."

    sudo cp -rfv "${K8S_FOLDER}/home/elevy/k3d" ~/
    sudo chmod 777 -R ~/k3d

    #	k3d cluster delete ginger
	  k3d cluster create ginger --api-port 6550 -p 8081:80@loadbalancer --agents 2 --volume /home/elevy/k3d/registries.yaml:/etc/rancher/k3s/registries.yaml

    k3d kubeconfig merge ginger --switch-context
    # it will create new k3d config file /home/elevy/.k3d/kubeconfig-ginger.yaml
    export KUBECONFIG="$(k3d kubeconfig get ginger)"
    # it will create new k3d config file /home/elevy/.kube/config.yaml

    # After cluster created you can check the expose api under: (password taken from /home/elevy/.k3d/kubeconfig-ginger.yaml)
    # https://0.0.0.0:6550 admin/4bca390983c31f091a997655482832fb
	else
	  echo "k3s_container=$k3s_container is RUNNING"
	fi

  docker ps -a
  curl localhost:6550/
}

function install_nginx(){
    kubectl create deployment nginx --image=nginx
    kubectl create service clusterip nginx --tcp=80:80
    kubectl apply -f /home/elevy/k3d/ingress.yaml
    curl localhost:8081/
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

###### skaffold ######
function install_skaffold() {
  # curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
  # chmod +x skaffold
  # sudo mv skaffold /usr/local/bin
  echo empty
}
##################################################

function addToPath() {
  if [ -d "$1" ]; then
    if [[ ":$PATH:" != *":$1:"* ]]; then
      #PATH="${PATH:+"$PATH:"}$1"
      PATH="$1${PATH:+":$PATH"}"
    fi
  fi
}

function ask(){
  echo $PASSWORD | sudo -S echo "Sudo Password :)"
  DEFAULT="y"
  while true ; do
#    echo -n "Would you like to run $1? [n/N]skip, [y/Y]run, [y]:"
    read -re -p "Would you like to run $1? [n/N]skip, [y/Y]run, [${DEFAULT}]:" action
      action="${action:-$DEFAULT}"

      case "$action" in
        [Nn])
          echo "skip running $1"
          break
          ;;
        [Yy])
          echo "Going to run $1"
          $1
          break
          ;;
        * )
          echo "You must type one of these char[n,N,y,Y]"
     	esac
  done
}


