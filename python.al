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
  touch $1/__init__.py
}

# python build
#pb(){ python setup.py sdist ;}
pb(){ python setup.py sdist bdist_wheel ;}

## JAVA ##

alias jar-list='jar tvf'

pypackinstall(){
  pip install --editable .
}

py3install(){
  python3 -m pip install --user --upgrade setuptools wheel
  python3 setup.py sdist bdist_wheel
}

pyscratchtest(){ python -m unittest test.scratch.Scratch ;}
pytest(){ python -m unittest ${@:1} ;}
pyinttest(){ python -m unittest discover -p *int_test.py ${@:1} ;}
pye2etest(){ python -m unittest discover --failfast -p *e2e_test.py ${@:1} ;}

i-python(){
  ## builds and installs python 3+ from source
  # NOTE: requires - gcc zlib-devel openssl-devel bzip2-devel libffi-devel
  # TODO: make configurable
  major=3
  minor=7
  patch=5
  version=${major}.${minor}.${patch}
  fname=Python-${version}
  tname=${fname}.tgz
  dname=python${major}.${minor}
  lname=python${major}
  curl -O https://www.python.org/ftp/python/${version}/${tname}
  tar -xzvf ${tname}
  cd ${fname}
  ./configure --prefix=/usr/local/${dname} --enable-optimizations
  make && make install
  ln -s /usr/local/${dname}/bin/${dname} /usr/bin/${lname}
  ln -s /usr/local/${dname}/bin/${dname} /usr/bin/${lname}${minor}
  ln -s /usr/local/${dname}/bin/pip /usr/bin/pip
  ln -s /usr/local/${dname}/bin/pip3 /usr/bin/pip3
  # ln -s /usr/local/${dname}/bin /usr/bin/ppython
  # echo 'PATH=$PATH:/usr/bin/ppython' > /etc/profile.d/ppython.sh
}
