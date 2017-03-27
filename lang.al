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

# TODO:
# - create virtual env (for python 3 and 2)
i-pip(){ curl https://bootstrap.pypa.io/get-pip.py | python ;}

# python 3 only atm

penv="${HOME}/penv/"
# venv create
pec(){
  if [[ $1 == "2" ]]; then
    #TODO add symlink in current dir
    python -m venv "${penv}/2"
  else
    python3 -m venv ${penv}
  fi

}
# venv install
pei(){
  [ -z $1 ] && req='requirements.txt' || req=$1
  dh ${py_img} source "${penv}/bin/activate" && pip install -r ${req}
}
# venv activate/deactivate
pea(){ source "${penv}/bin/activate" ;}
ped(){ deactivate ;}
