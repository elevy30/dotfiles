
#!/bin/bash

# print each command before runing it 
set -x

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
sudo apt --assume-yes install openjdk-8-jdk
sudo apt --assume-yes install openjdk-11-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JDK11_HOME=/opt/dev/java-11-openjdk-amd64
export GOOGLE_APPLICATION_CREDENTIALS=~/.ssh/tr-rnd-maven.json

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


addToPath(){
	if [ -d  "$1" ] && [[":$PATH:" != *":$1:"*]];
	then
		#PATH="${PATH:+"$PATH:"}$1"
		PATH="$1${PATH:+":$PATH"}"
	fi
}

# K8S 
# https://confluence.thetaray.com/pages/viewpage.action?spaceKey=DE&title=Working+with+the+Kubernetes+cluster

