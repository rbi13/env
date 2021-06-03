#!/bin/sh
## bitwarden password manager
#

i-bitwarden(){
  url='https://vault.bitwarden.com/download/?app=cli&platform=linux'
  zname='bitwarden.zip'
  xname='bw'
  xpath='/usr/local/bin/'
  curl -Ls ${url} > ${zname}
  unzip ${zname}
  chmod u+x ${xname}
  sudo mv ${xname} ${xpath}
  rm ${zname}
}
