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
ggquota(){ gcloud compute project-info describe ;}
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
    # --service-account ""\
    # --min-cpu-platform "Automatic"\
    # --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append"
}
ggprojectset(){
  [ -z $1 ] && prj=${GCP_DEFAULT_PROJECT} || prj=$1
  gcloud config set project ${prj}
}
ggproject(){ gcloud config get-value project ;}
gglogs(){
  gcloud logging read "resource.type=global AND jsonPayload.container.name=/$1 AND logName=projects/$2/logs/gcplogs-docker-driver" --limit 10
}

gfire(){
  if [ -z $1 ]; then
    gcloud compute firewall-rules list
  else
    name=$1
    port=$2
    ip=$3
    gcloud compute firewall-rules create ${name}\
      --allow=tcp:${port}\
      --source-ranges=${ip}
  fi
}

gconsole(){ open https://pantheon.corp.google.com/home/dashboard?project=$1 ;}

i-gcloud(){
  tarname='gcloudpkg.tar.gz'
  version='209.0.0'
  url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-linux-x86_64.tar.gz"
  curl -o ${tarname} ${url}
  untar ${tarname} && rm ${tarname}
  mv google-cloud-sdk ~/
  ~/google-cloud-sdk/install.sh
}

# snippets
snp(){
  if [ -z $1 ]; then
    gsutil ls ${GCP_SNIP_URL}
  else
    gsread ${GCP_SNIP_URL}/$1
  fi
}
snpw(){ gswrite ${GCP_SNIP_URL}/$1 ;}
snpd(){ gsutil rm ${GCP_SNIP_URL}/$1 ;}
gswrite(){
  gs_path=$1
  tmp_path="${HOME}/.wrt/"
  mkdir -p ${tmp_path}
  [ -z $2 ] && context="${tmp_path}/default" || context="${tmp_path}/$2"
  cbpaste > ${context}
  gsutil cp ${context} ${gs_path}
}
gsread(){
  gs_path=$1
  gsutil cat ${gs_path} | cbcopy
}

# bq
bqschema(){
  bq show --format=prettyjson --schema $1 > schema.json
}

## Source repos
ggr(){ gcloud source repos list --project=${GCP_REPO_PROJECT} ;}
ggrd(){
  [ -z $1 ] && repo=$(basename ${PWD}) || repo=$1
  gcloud source repos delete ${repo} --project=${GCP_REPO_PROJECT}
}
ggrc(){
  gcloud source repos create $1 --project=${GCP_REPO_PROJECT}
  [ $2=='c' ] && gcloud source repos clone $1 --project=${GCP_REPO_PROJECT} && cd $1
}
ggri(){
  [ -z $1 ] && repo=$(basename ${PWD}) || repo=$1
  gcloud source repos get-iam-policy ${repo} --project=${GCP_REPO_PROJECT} > iam.policy
  g iam.policy
}
ggris(){
  [ -z $1 ] && repo=$(basename ${PWD}) || repo=$1
  gcloud source repos set-iam-policy ${repo} --project=${GCP_REPO_PROJECT}  iam.policy
  rm iam.policy
}
ggra(){
  name=$1
  [ -z "$2" ] && gcloud source repos create ${name}
  url=$(gcloud source repos describe ${name} --flatten url | tail -1)
  git remote add origin ${url}
}
# gcloud source repos describe gsuite-report-sync --flatten url
# gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.sh
# git remote add origin https://source.developers.google.com/p/google.com:bondrdev/r/gsuite-report-sync

## Speech
spk(){
  [ -f "$1" ] && speech=$(cat $1) || speech=$1
  [ -z  $1 ] && speech=$(cbpaste)
  speech=$(echo ${speech} | sed "s/'/\\\'/g")
  curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  --data "{
    'input':{
      'text':'${speech}'
    },
    'voice':{
      'languageCode':'en-us',
      'name':'en-US-Wavenet-D',
      'ssmlGender':'MALE'
    },
    'audioConfig':{
      'audioEncoding':'MP3'
    }
  }" "https://texttospeech.googleapis.com/v1/text:synthesize" > /tmp/synthesize-text.txt

  sed 's|audioContent| |' < /tmp/synthesize-text.txt > /tmp/tmp-output.txt && \
  tr -d '\n ":{}' < /tmp/tmp-output.txt > /tmp/tmp-output-2.txt && \
  base64 /tmp/tmp-output-2.txt --decode > /tmp/audio.mp3 && \
  # rm tmp-output*.txt

  ffplay /tmp/audio.mp3 -nodisp -autoexit
}

voices(){
  curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
    -H "Content-Type: application/json; charset=utf-8" \
    "https://texttospeech.googleapis.com/v1/voices"
}


## Vision
# LOGO_DETECTION, LABEL_DETECTION, TEXT_DETECTION
# TODO if error.code 7||14
# TODO GCS version
saw(){
  [ -z  $1 ] && img=$(cbpaste) || img=$1
  source="'source':{ 'imageUri':'${img}' }"
  if [ -f "$1" ]; then
    img=$(base64 $1)
    source="'content':'${img}'"
  fi
  curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
  -H "Content-Type: application/json; charset=utf-8" \
  --data "{
    'requests':[
      {
        'image':{
          ${source}
        },
        'features':[
          { 'type':'LABEL_DETECTION' },
          { 'type':'LOGO_DETECTION' }
        ]
      }
    ]
  }" "https://vision.googleapis.com/v1/images:annotate"
}



# curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"
#
# curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
#   'https://iam.googleapis.com/v1/projects/postybot-218520/serviceAccounts/dialogflow-vumflw@postybot-218520.iam.gserviceaccount.com/keys'
#
# TOKEN_RESP=curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"
# curl -H 'Authorization: Bearer 'ya29.c.EmY0BsfFicr6ofLWbCzZkvrkxHTRcBsccEw6wAnTo87xEmvmBs-Shwvc5z9Nz7RoiLag8azKbK6RH3W45cPXwDsQq6BXYacaIZWPLH7uitKll4VVtGXfLzn-KKnKrpANuUVN0SvZI30 \
# -H 'Content-Type: application/json; charset=utf-8' \
# --data "{
#    'email': 'dialogflow-vumflw@postybot-218520.iam.gserviceaccount.com',
#    'scopes': [
#      'https://www.googleapis.com/auth/cloud-platform'
#   ]
#  }" 'https://www.googleapis.com/compute/v1/projects/postybot-218520/zones/us-east1-b/instances/innovapost-chat/setServiceAccount'

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
