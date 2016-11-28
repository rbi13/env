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