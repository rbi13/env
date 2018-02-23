#!/bin/sh
## Function list
#
## TODO
##

#== golang
GOPATH="${HOME}/ws/go"
go_img='golang'

py_img='python:2'

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

## PYTHON ##

# TODO:
# - create virtual env (for python 3 and 2)
i-pip(){ curl https://bootstrap.pypa.io/get-pip.py | python ;}

# python 3 only atm

penv="${HOME}/penv/"
# venv create
pec(){
  if [[ $1 == "2" ]]; then
    [[ -z $2 ]] && e="${penv}2" || e="$2/venv"
    virtualenv ${e}
  else
    [[ -z $1 ]] && e=${penv} || e="$1/venv"
    python3 -m venv ${e}
  fi
}
# venv install
pei(){
  [ -z $1 ] && req='requirements.txt' || req=$1
  dh ${py_img} source "${penv}/bin/activate" && pip install -r ${req}
}
# venv activate/deactivate
pea(){
  if [[ $1 == "2" ]]; then
    [[ ! -e "venv" ]] && ln -nfs "${penv}2" venv
  else
    [[ ! -e "venv" ]] && ln -nfs "${penv}" venv
  fi
  source "venv/bin/activate"
}
ped(){ deactivate ;}

# python build
#pb(){ python setup.py sdist ;}
pb(){ python setup.py sdist bdist_wheel ;}

## JAVA ##

alias jar-list='jar tvf'
