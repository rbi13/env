#!/bin/bash

alias gg='gcloud'
alias ggi='gcloud init'
alias ggl='gcloud config list'
alias ggc='gcloud beta compute'
alias ggci='ggc instances'
alias ggcd='ggc disks'
ggcil(){ ggci list ${@:1} ;}
ggcdl(){ ggcd list ${@:1} ;}

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
