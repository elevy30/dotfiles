#!/bin/bash

K8S_FOLDER=$(pwd)
source "${K8S_FOLDER}/scripts/util.sh"

####################
###### DOCKER ######
####################

# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
DOCKER_VERSION=5:19.03.12~3-0~ubuntu-focal

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

function docker_cleanup(){
  docker-compose down
  docker rm -f $(docker ps -a -q)
  docker volume rm $(docker volume ls -q)
  docker-compose up -d
}
