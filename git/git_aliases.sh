#!/bin/bash

##
# Git aliases collected from:
# https://dzone.com/articles/lesser-known-git-commands
# http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/
##

git config --global alias.please 'push --force-with-lease'
#Amend the previous commit with the same message.
git config --global alias.commend 'commit --amend --no-edit'
#Init new repository
git config --global alias.it '!git init && git commit -m “root” --allow-empty'
git config --global alias.stsh 'stash --keep-index'
git config --global alias.staash 'stash --include-untracked'
git config --global alias.staaash 'stash --all'
git config --global alias.shorty 'status --short --branch'
git config --global alias.merc 'merge --no-ff'
#Complete tree like log
git config --global alias.grog 'log --graph --abbrev-commit --decorate --all --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
#Log with the list of affected files.
git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
git config --global alias.pullr 'pull --rebase'
#Find a file in Git
git config --global alias.f '!git ls-files | grep -i'
#List all currently defined Git aliases.
git config --global alias.la '!git config -l | grep alias | cut -c 7-'
