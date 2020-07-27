#!/bin/bash
set -v 

######### GIT #########
  sudo apt-get update
  sudo apt --assume-yes install git-all
  
  git config --global user.name "elevy30"
  git config --global user.email "elevy30@gmail.com"

######### GIT-HUB #########
  sudo chmod 777 -R /opt
  
  dev=/opt/dev
  sudo mkdir -p $dev
  sudo chmod 777 -R $dev
  
  git clone https://elevy30:nlBI22pt!@github.com/elevy30/dotfiles.git $dev/dotfiles

######### CHROME ######### 
#  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
#  sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/  sources.list.d/google.list'
#  sudo apt-get update
#  sudo apt-get install google-chrome-stabledir = 
