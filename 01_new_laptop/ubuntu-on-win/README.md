# Prerequisite
#### - install ubuntu on window
#### - install docker on window
#### - install docker
#### - install python
https://medium.com/@sebagomez/installing-the-docker-client-on-ubuntus-windows-subsystem-for-linux-612b392a44c4
#### - make sure docker ps working 'docker ps'
#### - add this line to .zshrc/.profile
export DOCKER_HOST=tcp://localhost:2375


#### - install k3d (k3s on docker) with registry
#### add registry to /etc/hosts
C:\Windows\System32\drivers\etc   127.0.0.1 registry.local
/etc/hosts                        127.0.0.1 registry.local
#### - install kubectl
#### - add autocomplete to zsh/.profile
#### - install kubectx/kubens
#### - install k9s



