#!/bin/bash
alias gg='gcloud'
alias ggi='gcloud init'
alias ggisa='gcloud auth activate-service-account --key-file'
alias ggg='gg alpha interactive'
ggkey(){
  acct=$1
  gcloud iam service-accounts keys create ./secret.json \
    --iam-account ${acct}
}
ggupdate(){ gcloud components update ;}
ggquota(){ gcloud compute project-info describe ;}

ggsa(){ gcloud iam service-accounts list ;}
ggsad(){ gcloud iam service-accounts delete ${@:1} ;}
ggsac(){
  name='demosaa'
  project=`ggproject`
  user=`gguser`
  role='roles/owner'
  sa=${name}@${project}.iam.gserviceaccount.com
  gcloud iam service-accounts create ${name}\
    --display-name ${name}
  gcloud projects add-iam-policy-binding ${project} \
    --member serviceAccount:${sa} --role ${role}
  gcloud iam service-accounts add-iam-policy-binding ${sa} \
    --member user:${user} --role roles/iam.serviceAccountUser
  gcloud iam service-accounts keys create secret.json\
    --iam-account=${sa}
}

ggservices(){ gcloud services enable $1.googleapis.com ;}
ggservicesd(){ gcloud services disable $1.googleapis.com ;}

jupyterLab(){
  IMAGE_FAMILY="tf-latest-cpu"
  ZONE="us-east1-b"
  INSTANCE_NAME="jup"

  gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --image-family=$IMAGE_FAMILY \
    --image-project=deeplearning-platform-release
}
jupyterLabConnect(){
  INSTANCE_NAME="jup"
  gcloud compute ssh $INSTANCE_NAME -- -L 8080:localhost:8080
}

ggip(){
  gcloud compute instances describe $1\
    --format='get(networkInterfaces[0].accessConfigs.natIP)'
}

ggprojectset(){
  [ -z $1 ] && prj=${GCP_DEFAULT_PROJECT} || prj=$1
  gcloud config set project ${prj}
}
ggproject(){ gcloud config get-value project ;}
gguser(){ gcloud config get-value account ;}
ggprojectlist(){
  [ -z $1 ] && gcloud projects list || gcloud projects list | grep $1
}

gglogs(){
    gcloud logging logs list
}

gglogsdocker(){
  gcloud logging read "resource.type=global AND jsonPayload.container.name=/$1 AND logName=projects/$2/logs/gcplogs-docker-driver" --limit 10
}

# compute
ggce(){
  [ "$1" == 'id' ] && args=--format="value(name)" || args=${@:1}
  gcloud compute instances list ${args}
}
ggcec(){ gcloud compute instances create ${@:1} ;}
ggceccontainer(){ gcloud compute instances create ${@:1} ;}
ggced(){ gcloud compute instances delete ${@:1} ;}
ggcestart(){ gcloud compute instances stop ${@:1} ;}
ggcestop(){ gcloud compute instances stop ${@:1} ;}
ggssh(){ gcloud compute ssh $1 ;}
ggtunnel(){
  hostname=$1
  port=$2
  gcloud compute ssh ${hostname} -- -L ${port}:${hostname}:${port} -N -n
  # gcloud compute ssh ${hostname} -- -D ${port} -N
}
ggtunnelclient(){
  hostname=$1
  port=$2
  /usr/bin/google-chrome \
    --proxy-server="socks5://localhost:${port}" \
    --user-data-dir=/tmp/${hostname}
}
ggfire(){
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

# pubsub
ggpsub(){ gcloud pubsub subscriptions list --format="value(name)" ;}
ggpsubd(){ gcloud pubsub subscriptions delete ${@:1} ;}
ggpsubc(){ gcloud pubsub subscriptions create $1 --topic=$2 ;}
ggsubPull(){ gcloud pubsub subscriptions pull $1 ;}
# ggpsubreset(){
#   gcloud pubsub subscriptions delete $1
#   gcloud pubsub subscriptions create $1 --topic=$2
# }
ggptopic(){ gcloud pubsub topics list --format="value(name)" ;}
ggptopicc(){
  gcloud pubsub topics create ${@:1}
  # TODO: seperate function
  # [ -n "$2" ] && gcloud pubsub subscriptions create $2 --topic=$1
}
ggptopicd(){ gcloud pubsub topics delete ${@:1} ;}
ggptopicsub(){ gcloud pubsub topics list-subscriptions ${@:1} ;}
# ggptopicsubd(){ gcloud pubsub topics list-subscriptions $1 ;}

#templates
tpl(){
  if [ -z $1 ]; then
    gsutil ls ${GCP_TPL_URL}
  else
    gsutil cp -r ${GCP_TPL_URL}/$1 ./
  fi
}
tplw(){
  gsutil rsync -r ./ ${GCP_TPL_URL}/$1
  gswrite ${GCP_SNIP_URL}/$1
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
snpcat(){ gscat ${GCP_SNIP_URL}/$1 ;}
snpd(){ gsutil rm ${GCP_SNIP_URL}/$1 ;}
gswrite(){
  gs_path=$1
  tmp_path="${HOME}/.wrt/"
  mkdir -p ${tmp_path}
  [ -z $2 ] && context="${tmp_path}/default" || context="${tmp_path}/$2"
  cbpaste > ${context}
  gsutil cp ${context} ${gs_path}
}
gsread(){ gscat | cbcopy ;}
gscat(){
  gs_path=$1
  gsutil cat ${gs_path}
}

# dataflow
ggdf(){ gcloud dataflow jobs list ${@:1} ;}
ggdfj(){ gcloud dataflow jobs describe ${@:1} ;}
ggdfkillall(){
  gcloud dataflow jobs cancel `gcloud dataflow jobs list\
    --filter="state=running"\
    --format="value(JOB_ID)"`
}
ggdfkillsubs(){
  gcloud pubsub subscriptions delete `gcloud pubsub subscriptions list\
    --format="value(name)"\
    --filter="name~beam OR name~.subscription-"`

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
repos(){
  open "https://console.cloud.google.com/code/develop/repo?project=${GCP_REPO_PROJECT}"
}
repourl(){
  url=`git remote -v | grep -E 'origin.*fetch' | awk '{print $2}'`
  repo=`basename ${url}`
  read -r -d '' cm << EOM
  gcloud source repos clone ${repo} --project=${GCP_REPO_PROJECT}

  git config --global credential.https://source.developers.google.com.helper gcloud.sh
  git remote add upstream ${url}
  git push upstream master
EOM
  echo "${cm}"
  echo "${cm}" | cbcopy
}

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

ggdev(){
  export GOOGLE_CLOUD_PROJECT=`ggproject`
  export GOOGLE_APPLICATION_CREDENTIALS=$PWD/secret.json
  export GOOGLE_APPLICATION_CREDENTIALS_DK=/app/secret.json
}
ggudev(){
  unset GOOGLE_CLOUD_PROJECT
  unset GOOGLE_APPLICATION_CREDENTIALS
  unset GOOGLE_APPLICATION_CREDENTIALS_DK
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
    # --service-account ""\
    # --min-cpu-platform "Automatic"\
    # --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append"
}



goog(){
  base="https://console.cloud.google.com"
  [ -z $2 ] && p="project=$(ggproject)" || p="project=$2"
  case $1 in
    '' | home )
      path=home/dashboard
      ;;
    bill* )
      path=billing/unbilledinvoice
      ;;
    bq | bigquery )
      path=bigquery
      ;;
    df | dataflow )
      path=dataflow
      ;;
    iam )
      path=iam-admin/iam
      ;;
    gcs )
      path=storage/browser
      ;;
    gce )
      path=compute/instances
      ;;
    peering )
      path=networking/peering
      ;;
    rout* )
      path=networking/routes
      ;;
    fire* )
      path=networking/firewalls
      ;;
    netw* )
      path=networking
      ;;
    mle* )
      path=mlengine
      ;;
    cf | func* )
      path=fuctions
      ;;
    ae | gae | appe* )
      path=appengine
      ;;
    ps | pub | pubs* )
      path=cloudpubsub
      ;;
    * )
      path=$1
      ;;
  esac
  open "${base}/${path}?${p}&${oargs}"
}

i-gcloud(){
  tarname='gcloudpkg.tar.gz'
  version='209.0.0'
  url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-linux-x86_64.tar.gz"
  curl -o ${tarname} ${url}
  untar ${tarname} && rm ${tarname}
  mv google-cloud-sdk ~/
  ~/google-cloud-sdk/install.sh
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
