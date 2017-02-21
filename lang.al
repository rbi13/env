#!/bin/sh
## Function list
#
## TODO
##

GOPATH="${HOME}/ws/go"
go_img='golang'

py_img='python'

# mount GOPATH and set workdir (current)
go_b(){
  dri \
    -v ${GOPATH}:/go \
    -w "/go$(pwd | awk -F 'go' '{print $2}')" \
    ${go_img} ${@:1}
}
go(){ go_b go ${@:1} ;}
gor(){ go run ${@:1} ;}
godep(){ go_b godep ${@:1} ;}

# python
# TODO: create virtual env (for python 3 and 2)
# python 3 only atm

# venv create
pec(){ dh ${py_img} python -m venv env/ ;}
# venv install
pei(){
  [ -z $1 ] && req='requirements.txt' || req=$1
  dh ${py_img} pip install -r ${req}
}
# venv activate/deactivate
pea(){ source env/bin/activate ;}
ped(){ deactivate ;}
