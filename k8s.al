#!/bin/bash
#
# kubernetes
#
#

kctl_img='rbi13/kubectl'
binpath='/usr/local/bin/'

# TODO: test NOTE: not working for minikube (use i-kubectl)
xkubectl(){
	drc --net=host \
		-v ~/.minikube:/root/.minikube \
		-v ~/.kube:${HOME}/.kube \
		${kctl_img} kubectl ${@:1}
}
alias kctl='kubectl'

# default overrides:
#  - driver injection (macos)
#  - connect dk host client to minikube dk daemon
# TODO: proxy
# minikube start --docker-env HTTP_PROXY=http://$YOURPROXY:PORT \
#                 --docker-env HTTPS_PROXY=https://$YOURPROXY:PORT
minikube(){
	ex=$(which minikube)
	# driver injection
	[ ismac ] && [[ "$1" == "start" ]] \
		&& driver_arg='--vm-driver=xhyve' || driver_arg=''
	# run commmand
	eval ${ex} ${@:1} ${driver_arg}
	# deamon connect
	if [[ "$1" == "start" ]]; then
		eval $(minikube docker-env)
		echo "shell docker configured to use minikube daemon"
		echo "  (restart your terminal to undo this)"
	fi
}

i-minikube(){
	#TODO: default to latest
	[ -z $1 ] && version='0.14.0' || version=$1
	kernel=$(getkernel)
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${version}/minikube-${kernel}-amd64
	chmod +x minikube
	sudo mv minikube ${binpath}

	# xhyve docker-machine driver (macos requires)
	if [ ismac ]; then
		brew install docker-machine-driver-xhyve
		# docker-machine-driver-xhyve need root owner and uid
		sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
		sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
	fi
}

i-kubectl(){
	#TODO: default to latest
	[ -z $1 ] && version='1.4.4' || version=$1
	kernel=$(getkernel)
	curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v${version}/bin/${kernel}/amd64/kubectl
	chmod +x kubectl
	sudo mv kubectl ${binpath}
}
