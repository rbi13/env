#!/bin/sh
## Function list
# Docker
#
## TODO
##
# ddl=grep docker /var/log/messages

alias dkjenkins='docker run -d -p 8080:8080 -p 50000:50000 -v ~/.jenkins_data:/var/jenkins_home jenkins'
