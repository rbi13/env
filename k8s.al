#!/bin/bash
#
# kubernetes
#
#

kctl_img='rbi13/kubectl'

alias kubectl='drn --net=host\
	-v ~/.kube:/root/.kube \
	${kctl_img} kubectl'
alias kctl='kubectl'

i-minikube(){
	version=$1
	ismac && kernel=darwin || kernel=linux
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${version}/minikube-${kernel}-amd64
	chmod +x minikube
	sudo mv minikube /usr/local/bin/
}
