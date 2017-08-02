#!/bin/bash

##
# Git aliases collected from:
# https://dzone.com/articles/lesser-known-git-commands
# http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/
##

git config --global alias.please  'push --force-with-lease'
#Amend the previous commit with the same message.
git config --global alias.commend 'commit --amend --no-edit'

#Init new repository
git config --global alias.it      '!git init && git commit -m “root” --allow-empty'

git config --global alias.stsh    'stash --keep-index'
git config --global alias.staash  'stash --include-untracked'
git config --global alias.staaash 'stash --all'
git config --global alias.shorty  'status --short --branch'

#Find a file in Git
git config --global alias.f       '!git ls-files | grep -i'

#List all currently defined Git aliases.
git config --global alias.la      '!git config -l | grep alias | cut -c 7-'

#Rebase
git config --global alias.pullr   'pull --rebase'
git config --global alias.rebase  'rebase -i master'
#pick 33d5b7a Message for commit #1
#pick 9480b3d Message for commit #2 --> replace pick with fixup or squash 
#pick 5c67e61 Message for commit #3
git config --global alias.lrebase 'rebase -i HEAD~3' # -> git merge-base feature master
#git checkout master
#git merge temporary-branch
#Merage within new  merge commite 
git config --global alias.merc    'merge --no-ff'


#Complete tree like log
git config --global alias.grog    'log --graph --abbrev-commit --decorate --all --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
#Log with the list of affected files.
git config --global alias.ll      'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
git config --global alias.log     'log --oneline --decorate --no-merges'
git config --global alias.auther  'log shortlog --no-merges'