#!/bin/bash

export PASSWORD=elevy

function pause(){
  echo "$1"
  echo -n "Press any key to resume ..."
  read -r action
}

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
  DEFAULT="n"
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
