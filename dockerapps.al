#!/bin/sh
## Function list
# Docker
#
## TODO
##
# ddl=grep docker /var/log/messages

dk-jenkins(){ drc -p 8080:8080 -p 50000:50000 -v ~/.jenkins_data:/var/jenkins_home jenkins ;}
dk-tf(){
  id=`drp -p 8888:8888 tensorflow/tensorflow`
  sleep 2
  adr=`dl ${id} 2>&1 | grep localhost`
  open ${adr}
}
