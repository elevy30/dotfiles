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

source "${K8S_FOLDER}/scripts/util.sh"
source "${K8S_FOLDER}/scripts/k8s_docker.sh"
source "${K8S_FOLDER}/scripts/k8s_infra.sh"
source "${K8S_FOLDER}/scripts/k8s_k3d.sh"
##################################################

#ask remove_docker
#ask add_docker_registry
#ask install_docker
#ask create_docker_local_registry
ask install_kubectl
ask install_k3d
ask create_k3d_cluster
ask install_nginx
ask install_k9s
ask install_helm
ask copy_my_k8s_file

##################################################
set +x
popd >/dev/null || exit
##################################################

