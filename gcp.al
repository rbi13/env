#!/bin/bash

alias gg='gcloud'
alias ggi='gcloud init'
alias ggisa='gcloud auth activate-service-account --key-file'
alias ggl='gcloud config list'
alias ggc='gcloud beta compute'
alias ggci='ggc instances'
alias ggcd='ggc disks'
alias ggg='gg alpha interactive'
ggcil(){ ggci list ${@:1} ;}
ggcdl(){ ggcd list ${@:1} ;}
ggkey(){
  acct=$1
  gcloud iam service-accounts keys create ./key.json \
    --iam-account ${acct}
}

ggcic(){
  name=$1
  gcloud beta compute instances create ${name}\
    --machine-type "n1-standard-4"\
    --preemptible
    # --zone "us-east1-b"\
    # --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "datamigrator"\
    # --image "debian-9-stretch-v20180307" --image-project "debian-cloud"\
    # --subnet "default"\
    # --no-restart-on-failure\
    # --maintenance-policy "TERMINATE"\
    # --service-account "967060904397-compute@developer.gserviceaccount.com"\
    # --min-cpu-platform "Automatic"\
    # --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append"
}

ggproject(){ gcloud config get-value project ;}
gglogs(){
  gcloud logging read "resource.type=global AND jsonPayload.container.name=/$1 AND logName=projects/$2/logs/gcplogs-docker-driver" --limit 10
}

# https://pantheon.corp.google.com/home/dashboard?project=google.com:bondrdev
# https://console.cloud.google.com/code/develop/browse/cloudtemp/master?project=interviewgl-199716&authuser=1&organizationId=324726664201

#  /usr/bin/google_metadata_script_runner --script-type startup
# CentOS and RHEL: /var/log/messages
# Debian: /var/log/daemon.log
# Ubuntu 14.04, 16.04, and 16.10: /var/log/syslog
# SLES 11 and 12: /var/log/messages
# curl "http://metadata.google.internal/computeMetadata/v1/instance/tags?wait_for_change=true" -H "Metadata-Flavor: Google"

# curl "http://metadata.google.internal/computeMetadata/v1/instance/disks/" -H "Metadata-Flavor: Google"



## Example startup-script
#! /bin/bash
# VALUE_OF_FOO=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/foo -H "Metadata-Flavor: Google")
# apt-get update
# apt-get install -y apache2
# cat <<EOF > /var/www/html/index.html
# <html><body><h1>Hello World</h1>
# <p>The value of foo: $VALUE_OF_FOO</p>
# </body></html>
# EOF

# #! /bin/bash
# apt-get update
# apt-get install -y git
# curl https://raw.githubusercontent.com/rbi13/env/master/install.sh | sh && source ~/.bashrc


# Rerun startup script
# sudo google_metadata_script_runner --script-type startup

# gcloud logging read “resource.type=global AND jsonPayload.container.name=/fluent1 AND logName=projects/[PROJECT_ID]/logs/gcplogs-docker-driver” \
#     --limit 10

i-gcloud(){
  tarname='gcloudpkg.tar.gz'
  version='209.0.0'
  url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-linux-x86_64.tar.gz"
  curl -o ${tarname} ${url}
  untar ${tarname} && rm ${tarname}
  mv google-cloud-sdk ~/
  ~/google-cloud-sdk/install.sh
}


## Source repos
gcr(){
  gcloud source repos create $1
  [ $2=='c' ] && gcloud source repos clone $1 && cd $1
}

# TODO
# set policies via command line (need templating ):
# gcloud source repos set-iam-policy <repo> ...

# open repos from terminal:
# https://pantheon.corp.google.com/code/develop/browse/gsuite-report-sync?project=google.com:bondrdev

# setup remote on repo creation (add to gcr command)
# gcloud source repos describe gsuite-report-sync --flatten url
# gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.sh
# git remote add origin https://source.developers.google.com/p/google.com:bondrdev/r/gsuite-report-sync
