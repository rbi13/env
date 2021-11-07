#!/bin/bash

alias kb='kubectl'
kbcomplete(){ source <(kubectl completion bash) ;}
kbinfo(){ kubectl cluster-info ;}

i-minikube(){
	name="minikube-linux-amd64"
	lnk="https://storage.googleapis.com/minikube/releases/latest/${name}"
	curl -LO ${lnk}
	sudo install ${name} /usr/local/bin/minikube
	rm ${name}
}

i-kubectl(){
	name='kubectl'
	relcmd='curl -L -s https://dl.k8s.io/release/stable.txt'
	lnk="https://dl.k8s.io/release/$(relcmd)/bin/linux/amd64/kubectl"
	curl -LO ${lnk}
	sudo install -o root -g root -m 0755 ${name} /usr/local/bin/kubectl
	rm ${name}
}
