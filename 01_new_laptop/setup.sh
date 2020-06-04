#!/usr/bin/env zsh
#set -v

##################################################
pushd `dirname "$0"` > /dev/null

mkdir -p /opt/dev
cd /opt/dev
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
