#!/bin/bash

###### CHROME ######
function install_chrome() {
  if [ ! -e "google-chrome-stable_*.deb" ]; then
    echo "!!!!!!! google-chrome-stable_*.deb file -- NOT -- exist !!!!!!!"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  else
    echo "vvvvvvv google-chrome-stable_*.deb already exist vvvvvvv"
  fi
  sudo apt install ./google-chrome-stable_current_amd64.deb

  cp -rfv "${SETUP}/usr/share/applications/google-chrome.desktop" "/usr/share/applications"
  sudo chmod +x /usr/share/applications/google-chrome.desktop
}

###### Mint Cinnamon Desktop ######
function install_desktop() {
  sudo apt install cinnamon-desktop-environment

  # sudo apt install ubuntu-mate-desktop
  # sudo apt-get install xfce4

  # sudo add-apt-repository ppa:embrosyn/cinnamon
  # sudo apt --assume-yes update
}

###### ZSH - OH-MY-ZSH - GIT-PLUGINS  ######
function install_zsh() {
  sudo apt --assume-yes install zsh

  OH_MY_ZSH=~/.oh-my-zsh
  if [ ! -d "${OH_MY_ZSH}" ]; then
    echo "!!!!!!! .oh-my-zsh file -- NOT -- exist !!!!!!!"
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  else
    echo "vvvvvvv .oh-my-zsh already exist vvvvvvv"
  fi

  AUTO_SUGGEST=~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  if [ ! -d "${AUTO_SUGGEST}" ]; then
    echo "!!!!!!! zsh-autosuggestions file -- NOT -- exist !!!!!!!"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  else
    echo "vvvvvvv zsh-autosuggestions already exist vvvvvvv"
  fi

  sudo apt --assume-yes install fonts-powerline

  GIT_PROMPT=~/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh
  if grep -Fxq "setopt PROMPT_SUBST" ${GIT_PROMPT}; then
    echo "vvvvvvv git-prompt.plugin.zsh already -- WAS CHANGED -- vvvvvvv"
  else
    echo "!!!!!!! git-prompt.plugin.zsh will be update with prompt color !!!!!!!"
    cp -rfv "$(SETUP)/home/elevy/git-prompt.plugin.zsh" ~/.oh-my-zsh/plugins/git-prompt/

    ## add these lines to the end of the file ~/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh
    ## RPROMPT='$(git_super_status)'
    ## setopt PROMPT_SUBST
    ## PROMPT='%(!.%F{red}.%F{cyan})%n%f %F{red}@%f %{%F{yellow bold}$(pwd)%${#PWD}G%}%f $(git_super_status)'

    # sed -e '/RPROMPT*/ s/^#*/#/g' -i ${GIT_PROMPT}
    # {
    #   echo "setopt PROMPT_SUBST";
    #   echo "PROMPT='%("'!'".%F{red}.%F{cyan})%n%f %F{red}@%f %{%F{yellow bold}\$(pwd)%\${#PWD}G%}%f \$(git_super_status)'";
    #   echo "";
    # } >> ${GIT_PROMPT}

  fi

  ZSH=~/.zshrc
  sed -e 's/plugins=(git)/plugins=(git git-prompt zsh-autosuggestions)/g' -i ${ZSH}
  {
    echo "alias python=python3";
    echo "source ~/.oh-my-zsh/plugins/git-prompt/git-prompt.plugin.zsh";
    echo "";
    echo "$HOME/.dropbox-dist/dropboxd";
    echo "";
  } >> ${ZSH}

  sudo chmod 755 -R ~/.oh-my-zsh/plugins
  sudo chsh -s "$(hash zsh)" "$(whoami)"
  #sudo chsh -s /bin/sh

  cd "${TEMP}" || exit

  ###### ZSH - SSH  ######
  #  ZSH=~/.zshrc
  #  echo "ssh-add ~/.ssh/tr-key.pem" >> ${ZSH}
}

###### MAVEN ######
function install_maven() {
  sudo apt --assume-yes install maven
  mvn -version
  M2_HOME=/usr/share/maven
  addToPath "${M2_HOME}/bin"
}

###### JAVA ######
function install_java() {
  # https://docs.datastax.com/en/jdk-install/doc/jdk-install/installOpenJdkDeb.html
  sudo apt --assume-yes install openjdk-8-jdk
  sudo apt --assume-yes install openjdk-11-jdk
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
  export JDK11_HOME=/usr/lib/jvm/java-11-openjdk-amd64
  export GOOGLE_APPLICATION_CREDENTIALS=~/.ssh/tr-rnd-maven.json
}

###### TERMINATOR ######
function install_terminator() {
  sudo apt --assume-yes install terminator
  # sudo update-alternatives --config x-terminal-emulator
  # check if python is the expected version
  mkdir -p ~/.config/terminator
  TERMINATOR=~/.config/terminator/config
  touch ${TERMINATOR}

/bin/cat <<EOM >$TERMINATOR
[profiles]
  [[default]]
    scrollback_infinite = True
EOM
}

###### DROPBOX ######
function install_dropbox() {
  DROPBOX=~/.dropbox-dist/dropboxd

  if [ -n "$(pgrep dropbox)" ]; then
    echo "!!!!!!! ${DROPBOX} file -- NOT -- exist !!!!!!!"
    cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  else
    echo "vvvvvvv ${DROPBOX} already exist vvvvvvv"
  fi

  if pgrep "dropbox" >/dev/null; then
    echo "Dropbox in running"
  else
    echo "Dropbox is not running"
    ~/.dropbox-dist/dropboxd &
  fi

  sudo cp -rfv "${SETUP}/etc/init.d/dropbox" /etc/init.d/
  sudo chmod +x /etc/init.d/dropbox
  sudo update-rc.d dropbox defaults

  echo "Add Dropbox to startup-application 'sh -c ~/.dropbox-dist/dropboxd'"
  read -pr "press ENTER when done"
}

###### SUBLIME ######
function install_sublime() {
  SUBLIME='sublime-text'
  if [ "$(dpkg-query -W -f='${Status}' ${SUBLIME} 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    echo "!!!!!!! ${SUBLIME} already install !!!!!!!"
    sudo apt update
    sudo apt --assume-yes install apt-transport-https ca-certificates curl software-properties-common
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
    sudo apt update
    sudo apt --assume-yes install sublime-text
  else
    echo "vvvvvvv ${SUBLIME} already install vvvvvvv"
  fi
}

###### CopyQ ######
function install_copyq() {
  COPYQ='copyq'
  if [ "$(dpkg-query -W -f='${Status}' ${COPYQ} 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    echo "!!!!!!! ${COPYQ} already install !!!!!!!"
    sudo apt --assume-yes install copyq
  else
    echo "vvvvvvv ${COPYQ} already install vvvvvvv"
  fi

  echo ###### configure the shortcut key ######
  echo "open show/hide -> press F6 -> press the \"+ Add\" -> select \"Show/hide main window\" -> add shortcut \"ctrl+\`"
  read -pr "press ENTER when done"

  echo "Add CopyQ to startup-application 'copyq'"
  read -pr "press ENTER when done"
}


addToPath() {
  if [ -d "$1" ]; then
    if [[ ":$PATH:" != *":$1:"* ]]; then
      #PATH="${PATH:+"$PATH:"}$1"
      PATH="$1${PATH:+":$PATH"}"
    fi
  fi
}

##################################################