#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)
DOTFILES_LN="$HOME/.dotfiles"
GIT_AUTHER_NAME="eyal.levy"
GIT_AUTHER_EMAIL="eyal.levy@thetaray.com"


set -e

echo ''

info () {
  printf "\r  [ \033[00;35m..\033[0m ] $1 $2\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1 ($2)"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f git/gitconfig.local.symlink ]
  then
    info 'setup gitconfig'

    user ' - What is your github author name?' $GIT_AUTHER_NAME
    read -e git_author_name 
    git_author_name=${git_author_name:-$GIT_AUTHER_NAME} 
	info 'git_author_name = ' $git_author_name

    user ' - What is your github author email?' $GIT_AUTHER_EMAIL
    read -e git_author_email 
	git_author_email=${git_author_email:-$GIT_AUTHER_EMAIL} 
	info 'git_author_email = ' $git_author_email

    sed -e "s/AUTHORNAME/$git_author_name/g" -e "s/AUTHOREMAIL/$git_author_email/g" git/.gitconfig.user  | cat - git/.gitconfig.template > temp && mv temp git/.gitconfig.symlink

    success 'gitconfig was set in your home directory'
  fi
}

link_main_folder () {
	echo "link $DOTFILES_ROOT to $DOTFILES_LN"
	#ln -s "$DOTFILES_ROOT" "$DOTFILES_LN"
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "symlink created - linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  # for src in $(find -H "$DOTFILES_LN" -maxdepth 2 -name '.*' -not -path '*.git*')
  for src in $(find -H "$DOTFILES_LN" -maxdepth 2 -type f -name '*.symlink')
  do
  	# tmp=${src%_*} -> remove suffix starting with "."
    dst="$HOME/$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

install_dotfolders () {
  info 'installing dotfolders'

  local overwrite_all=false backup_all=false skip_all=false

  # for src in $(find -H "$DOTFILES_LN" -maxdepth 2 -name '.*' -not -path '*.git*')
  for src in $(find -H "$DOTFILES_LN" -mindepth 1 -maxdepth 1 -type d -name '.*')
  do
  	# tmp=${src#*_} -> remove prefix ending with "." 
    dst="$HOME/$(basename "${src#*.}")"
    echo "link $src to $dst"
    link_file "$src" "$dst"
  done
}

link_main_folder
setup_gitconfig
install_dotfiles
install_dotfolders

echo ''
echo '  All installed!'


# install_zsh () {
# # Test to see if zshell is installed.  If it is:
# if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
#     # Clone my oh-my-zsh repository from GitHub only if it isn't already present
#     if [[ ! -d $dir/oh-my-zsh/ ]]; then
#         git clone http://github.com/robbyrussell/oh-my-zsh.git
#     fi
#     # Set the default shell to zsh if it isn't currently set to zsh
#     if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
#         chsh -s $(which zsh)
#     fi
# else
#     # If zsh isn't installed, get the platform of the current machine
#     platform=$(uname);
#     # If the platform is Linux, try an apt-get to install zsh and then recurse
#     if [[ $platform == 'Linux' ]]; then
#         if [[ -f /etc/redhat-release ]]; then
#             sudo yum install zsh
#             install_zsh
#         fi
#         if [[ -f /etc/debian_version ]]; then
#             sudo apt-get install zsh
#             install_zsh
#         fi
#     # If the platform is OS X, tell the user to install zsh :)
#     elif [[ $platform == 'Darwin' ]]; then
#         echo "Please install zsh, then re-run this script!"
#         exit
#     fi
# fi
# }
# install_zsh

