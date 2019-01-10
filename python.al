#!/bin/sh
## Function list
#
## TODO
##

# TODO:
# - create virtual env (for python 3 and 2)
i-pip(){
  url='https://bootstrap.pypa.io/get-pip.py'
  if [ -z $1 ]; then
    curl $url | python
  else
    curl $url | sudo python
  fi
}

# python virtual environment (docker boot-stratpped)
pyenv(){
  if [ ! -e ./venv  ]; then
    if [[ $1 == "2" ]]; then
      dripf python:2 virtualenv ./venv
    else
      dripf python:3 python3 -m venv ./venv
    fi
  fi
  source "venv/bin/activate"
}
pyenvd(){ deactivate ;}
pyenvdd(){ rm -rf venv ;}

ppi(){ pip install -r requirements.txt ;}
ppf(){ pip freeze > requirements.txt ;}
pydir(){ touch __init__.py ;}

mkpimodule(){
  mkdir $1
  touch $1/__init.py
}

# python build
#pb(){ python setup.py sdist ;}
pb(){ python setup.py sdist bdist_wheel ;}

## JAVA ##

alias jar-list='jar tvf'
