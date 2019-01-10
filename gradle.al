#!/bin/bash

alias gr='gradle'
grswitch(){
  alt='./build.gradle.alt'
  use='build.gradle'
  default='build.gradle.default'
  if [ -f ${alt} ]; then
    mv ${use} ${default}
    mv ${alt} ${use}
  else
    mv ${use} ${alt}
    mv ${default} ${use}
  fi
}
gw(){
  alt='./build.gradle.alt'
  if [ -f ${alt} ] && [ -z ${NO_ALT} ]; then
    ./gradlew -b ${alt} ${@:1}
  else
    ./gradlew ${@:1}
  fi

}
#alias grd='gr depI --dependency'
#alias grhp='gr help --task'

grd(){
  drbp -u root gradle ${@:1}
}

grb(){
  case "$1" in
  java|jv)
    opts='--type java-application --test-framework spock'
    ;;
  javalibs|jvl)
    opts='--type java-library --test-framework spock'
    ;;
  *)
    opts=''
  esac
  echo "gradle init ${opts}"
  dhe -u root gradle gradle init ${opts}
  own
}

# @experimental
gr-getjre(){
  dcpi gradle /docker-java-home/bin ./java/bin
  dcpi gradle /docker-java-home/include ./java/include
  dcpi gradle /docker-java-home/jre ./java/jre
  dcpi gradle /docker-java-home/lib ./java/lib
  dcpi gradle /docker-java-home/man ./java/man
  dcpi gradle /docker-java-home/ASSEMBLY_EXCEPTION ./java/ASSEMBLY_EXCEPTION
  dcpi gradle /docker-java-home/THIRD_PARTY_README ./java/THIRD_PARTY_README
}

# project init templates
# gr init --type java-library
# https://docs.gradle.org/current/userguide/build_init_plugin.html

# plugins
# // shadow jar
# 'com.github.johnrengelman.shadow' version '1.2.3'
# // ssh
# 'org.hidetake.ssh' version '2.5.1'
# // docker
# 'com.bmuschko:gradle-docker-plugin' version '3.0.2'
# 'com.avast.gradle:docker-compose-gradle-plugin' version '0.3.8'
# 'com.palantir.docker' version '<version>'
# // Python
# https://github.com/linkedin/pygradle
#
