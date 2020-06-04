#!/bin/bash

# print each command before runing it
# set -v 
# set -x

##################################################
pushd `dirname "$0"` > /dev/null




mkdir -p /opt/dev
cd /opt/dev

SETUP_FOLDER=/opt/dev/new_laptop

# SSH
cp -rvf  ${SETUP_FOLDER}/.ssh ~/
chmod 600 ~/.ssh/tr-key.pem

# TR_GIT 
ssh-add ~/.ssh/tr-key.pem
cd /opt/dev
git clone git@bitbucket.org:thetaray/tr-backend.git

# GITHUB
git clone https://elevy30:nlBI22pt@github.com/elevy30/dotfiles.git

# MAVEN 
if [ ! -d "/opt/apache-maven-3.6.3" ]; 
then
    cp -rfv ${SETUP_FOLDER}/apache-maven-3.6.3 /opt/
fi
export M2_HOME=/opt/apache-maven-3.6.3
export MAVEN_HOME=/opt/apache-maven-3.6.3
addToPath ${M2_HOME}/bin

# JAVA
# https://docs.datastax.com/en/jdk-install/doc/jdk-install/installOpenJdkDeb.html
sudo apt --assume-yes install openjdk-8-jdk
sudo apt --assume-yes install openjdk-11-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JDK11_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export GOOGLE_APPLICATION_CREDENTIALS=11/.ssh/tr-rnd-maven.json

# TERMINATOR
sudo apt --assume-yes install terminator
sudo update-alternatives --config x-terminal-emulator

# ZSH 
sudo apt --assume-yes install zsh
if [ ! -d "~/.oh-my-zsh" ]; 
then
    cp -rfv ${SETUP_FOLDER}/zsh/.oh-my-zsh ~/
    cp -rfv ${SETUP_FOLDER}/zsh/.zshrc ~/
fi
chsh -s $(which zsh)
#chsh -s /bin/sh

set +x

# DROPBOX
echo install DROPBOX
read -p "press ENTER when done"

# SUBLIME
echo install SUBLIME
read -p "press ENTER when done"

# CopyQ
echo install COPYQ
echo open show/hide -> press F6 -> press the "+ Add" -> select "Show/hide main window" -> add shortcut "ctrl+`
read -p "press ENTER when done" 

# K8S
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# https://github.com/derailed/k9s
sudo apt update
sudo snap install k9s

# skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
sudo mv skaffold /usr/local/bin

addToPath(){
    if [ -d  "$1" ] && [[":$PATH:" != *":$1:"*]];
    then
        #PATH="${PATH:+"$PATH:"}$1"
        PATH="$1${PATH:+":$PATH"}"
    fi
}

# K8S 
# https://confluence.thetaray.com/pages/viewpage.action?spaceKey=DE&title=Working+with+the+Kubernetes+cluster





















ln -sfn /mnt/d/dev/git-hub/ginger /opt/dev/ginger

HELM=/usr/local/bin/helm
if [ ! -f "$HELM" ]; then
    echo "$HELM not exist"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    /opt/dev/helm/get_helm.sh
fi

K9S=/usr/local/bin/k9s
if [ ! -f "$K9S" ]; then
    echo "$K9S not exist"
    wget  https://github.com/derailed/k9s/releases/download/v0.19.4/k9s_Linux_x86_64.tar.gz
    tar xvzf k9s_Linux_x86_64.tar.gz
    rm -rf LICENSE README.md k9s_*
    sudo mv k9s /usr/local/bin/
fi

popd > /dev/null
##################################################

sudo chmod 777 -R /home/elevy/.oh-my-zsh/plugins
AUTO_SUGGEST=~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
if [ ! -d "$AUTO_SUGGEST" ]; then
  echo "$AUTO_SUGGEST not exist"
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

sudo cp -rf /opt/dev/ginger/setup/home/elevy/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh /home/elevy/.oh-my-zsh/plugins/git-prompt
sudo chmod 755 /home/elevy/.oh-my-zsh/plugins
sudo chmod 755 /home/elevy/.oh-my-zsh/plugins/git
sudo chmod 755 /home/elevy/.oh-my-zsh/plugins/git-prompt
sudo chmod 755 /home/elevy/.oh-my-zsh/plugins/git-prompt/gitstatus.py

sudo cp -rf /opt/dev/ginger/setup/home/elevy/.k8s  /home/elevy
sudo cp -rf /opt/dev/ginger/setup/home/elevy/.profile  /home/elevy
sudo cp -rf /opt/dev/ginger/setup/home/elevy/.zshrc  /home/elevy

sudo cp -rf /opt/dev/ginger/setup/home/elevy/.k9s/config.yml  /home/.k9s
sudo cp -rf /opt/dev/ginger/setup/home/elevy/.k9s/hotkey.yml  /home/.k9s

sudo cp -rf /opt/dev/ginger/setup/usr/local/bin/k3d  /usr/local/bin
sudo cp -rf /opt/dev/ginger/setup/usr/local/bin/kubectl  /usr/local/bin
sudo cp -rf /opt/dev/ginger/setup/usr/local/bin/kubens  /usr/local/bin


sudo chmod +x /usr/local/bin/k3d
sudo chmod +x /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubens






#k3d create --enable-registry --server-arg "--no-deploy=traefik"
kubectl create namespace local

kubectl config get-contexts
kubectl cluster-info
kubectl get pods --all-namespaces
