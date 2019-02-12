#!/bin/bash

trfimg(){
  [ -z ${TERRAFORM_VERSION} ]  && version=light || version=${TERRAFORM_VERSION}
  echo hashicorp/terraform:${version}
}

tout(){ trf output -module=${@:1} ;}
tv(){ trf validate ${@:1} ;}
tp(){ trf plan ${@:1} ;}
ta(){ trf apply -auto-approve ${@:1} ;}
ti(){ trf init ;}
tir(){
  sudo rm -rf .terraform/terraform.tfstate terraform.tfstate.backup
  trf init -input=false
}
