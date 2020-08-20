#!/bin/bash
##################################################
# print each command before running it
#set -v
#set -x

# this declared that the current user is a sudoer
# PASSWORD=elevy
# echo $PASSWORD | sudo tee /etc/sudoer.d/$USER <<END
# END
##################################################
pushd "$(dirname "$0")" >/dev/null || exit
##################################################

#ROOT = /opt/dev/dotfiles/01_new_laptop
ROOT=$(pwd)

SETUP=${ROOT}/../setup
TEMP=${ROOT}/../temp

echo "ROOT=${ROOT}"
echo "SETUP=${SETUP}"
echo "TEMP=${TEMP}"

source "${SETUP}/functions.sh"

sudo mkdir -p "${TEMP}"
sudo chmod 777 -R "${TEMP}"
cd "${TEMP}"

#install_chrome
#install_desktop
#install_zsh
#install_maven
#install_java
#install_terminator
#install_dropbox
#install_sublime
#install_copyq

##################################################
set +x
popd >/dev/null || exit
##################################################
