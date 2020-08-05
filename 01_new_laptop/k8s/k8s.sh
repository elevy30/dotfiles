#!/bin/bash
##################################################
# print each command before running it
#set -v
#set -x

# this declared that the current user is a sudoer
PASSWORD=elevy
# echo $PASSWORD | sudo tee /etc/sudoer.d/$USER <<END
# END
##################################################
pushd "$(dirname "$0")" >/dev/null || exit
##################################################

#ROOT = /opt/dev/dotfiles/01_new_laptop
K8S_FOLDER=$(pwd)
ROOT="$(pwd)/.."

echo "K8S_FOLDER=${K8S_FOLDER}"
echo "ROOT=${ROOT}"

source "${K8S_FOLDER}/functions.sh"
##################################################

#ask remove_docker
#ask add_docker_registry
#ask install_docker
#ask create_docker_local_registry
#ask install_kubectl
#ask install_k3d
ask create_k3d_cluster
#ask install_nginx
ask install_k9s

##################################################
set +x
popd >/dev/null || exit
##################################################

