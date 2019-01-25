#!/bin/bash

java_img='openjdk:8'

gijava(){
  [ -f ".gitignore" ] && { echo "gitignore exists, aborting."; return 1 ;}
  gi java .gitignore
  gi gradle .gitignore
  gi intellij .gitignore
  gi eclipse .gitignore
}

fdjavaclasspath(){
  for jar in `find ${PWD} -type f -name \*.jar`; do
    ret=${ret}:${jar}
  done
  echo ${ret}
}

mkjavasrc(){
  src=$(echo $1 | sed "s/\./\\//g")
  mkdir -p "src/main/java/${src}"
  mkdir -p "src/test/java/${src}"
}

jv(){
  dri \
    -v ~/ws/go:/go -v ~/:/root/\
    -w /go$(pwd | awk -F "$USER/ws/go" '{print $2}')\
    ${java_img} ${@:1}
}

mclookup(){
  echo $2
  if [ -z $2 ]; then
    search=$1
    open "https://mvnrepository.com/search?q=${search}"
  else
    groupid=$1
    artifactid=$2
    [ -n "$3" ] && version=$3 || version='latest'
    open "https://mvnrepository.com/artifact/${groupid}/${artifactid}/${version}"
  fi
}


#https://docs.oracle.com/javase/${version}/docs/api/java/io/Reader.html

# gradle init --type java-library
# gradle init --type java-application --test-framework spock|testing

## prebuilt binary
# https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
# https://github.com/AdoptOpenJDK/openjdk8-releases/releases/download/jdk8u172-b11/OpenJDK8_x64_Linux_jdk8u172-b11.tar.gz
## package manager
# sudo apt-get install openjdk-8-jdk
