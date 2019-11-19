#!/bin/bash
alias gg='gcloud'
alias ggi='gcloud init'
ggprofileset(){
  [ -z $1 ] && profile=default || profile=$1
  gcloud config configurations activate ${profile}
}
ggprofile(){
  gcloud config configurations list
}
alias ggisa='gcloud auth activate-service-account --key-file'
alias ggg='gg alpha interactive'
ggconf(){
  [ -z $1 ] && conf='config_default' || conf=$1
  vi ~/.config/gcloud/configurations/config_${conf}
}
ggkey(){
  acct=$1
  gcloud iam service-accounts keys create ./secret.json \
    --iam-account ${acct}
}
ggupdate(){ gcloud components update ;}
ggquota(){ gcloud compute project-info describe ;}

ggnewproject(){
  pid=$1
  gcloud projects create ${pid}\
    --organization=${GCP_ORG}\
    --set-as-default
  gcloud beta billing projects link ${pid}\
    --billing-account=${GCP_BILLING}
}

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

ggservices(){ gcloud services list ;}
ggservicesenable(){ gcloud services enable $1.googleapis.com ;}
ggservicesdisable(){ gcloud services disable $1.googleapis.com ;}

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

gguser(){ gcloud config get-value account ;}
gguserset(){ gcloud auth login ;}

ggprojects(){ [ -z $1 ] && gcloud projects list || gcloud projects list | grep $1 ;}
ggproject(){ gcloud config get-value project ;}
ggprojectset(){
  [ -z $1 ] && prj=${GCP_DEFAULT_PROJECT} || prj=$1
  gcloud config set project ${prj}
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
ggcestart(){ gcloud compute instances start ${@:1} ;}
ggcestop(){ gcloud compute instances stop ${@:1} ;}
ggssh(){ gcloud compute ssh ${@:1} ;}
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
ggfired(){ gcloud compute firewall-rules delete ${@:1} ;}

# images
ggimagec(){
  name=$1
  source=$2
  gcloud beta compute images create ${name} \
    --source-disk=${source} \
    --storage-location=us
    # --source-disk-zone= \
    # --project= \
}


# datarpoc
ggdp(){ gcloud dataproc clusters list ${@:1} ;}
ggdpc(){ gcloud dataproc clusters create ${@:1} ;}
ggdpd(){ gcloud dataproc clusters delete ${@:1} ;}
#ggprocj

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

#flows
ggbucketnotify(){
  bucket="gs://$1"
  topic=$1
  sub=$1
  gsutil mb ${bucket}
  # topic created in this call (if not exists)
  gsutil notification create -t ${topic} -f json ${bucket}
  ggpsubc ${sub} ${topic}
}

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
  rite ${GCP_SNIP_URL}/$1
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
gsnp(){
  tmp_path="/tmp/${HOME}/" && mkdir -p ${tmp_path}
  context="${tmp_path}/gsnp"
  gsutil cp ${GCP_SNIP_URL}/$1 ${context}
  g ${context}
}
gswrite(){
  gs_path=$1
  tmp_path="/tmp/${HOME}/.wrt/"
  mkdir -p ${tmp_path}
  [ -z $2 ] && context="${tmp_path}/default" || context="${tmp_path}/$2"
  cbpaste > ${context}
  gsutil cp ${context} ${gs_path}
}
gsread(){ gscat ${@:1} | cbcopy ;}
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
bqmkschema(){
  bq mk --schema schema.json $1
}
bqclear(){
  bq rm $1 && bq mk --schema schema.json $1
}

## Source repos
# service acct checkouts
# git config --global credential.helper gcloud.sh
ggr(){
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  gcloud source repos list ${prj}
}
ggrd(){
  [ -z $1 ] && repo=$(basename ${PWD}) || repo=$1
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  gcloud source repos delete ${repo} ${prj}
}
ggrc(){
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  gcloud source repos create $1 --project=${GCP_REPO_PROJECT}
  [ $2=='c' ] && gcloud source repos clone $1 ${prj} && cd $1
}
ggri(){
  [ -z $1 ] && repo=$(basename ${PWD}) || repo=$1
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  gcloud source repos get-iam-policy ${repo} ${prj} > iam.policy
  g iam.policy
}
ggris(){
  [ -z $1 ] && repo=$(basename ${PWD}) || repo=$1
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  gcloud source repos set-iam-policy ${repo} ${prj}  iam.policy
  rm iam.policy
}
ggrclone(){
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  gcloud source repos clone $1 ${prj} && cd $1
}
ggra(){
  [ -z ${GCP_REPO_PROJECT} ] && prj='' || prj="--project=${GCP_REPO_PROJECT}"
  name=$1
  [ -z "$2" ] && gcloud source repos create ${name} ${prj}
  url=$(gcloud source repos describe ${name} --flatten url | tail -1)
  git remote add origin ${url}
}
repos(){
  [ -z ${GCP_REPO_PROJECT} ] && prj=`ggproject` || prj="--project=${GCP_REPO_PROJECT}"
  open "https://console.cloud.google.com/code/develop/repo?project=${prj}"
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
  export GOOGLE_APPLICATION_CREDENTIALS_DKC=/secret.json
  export GOOGLE_APPLICATION_CREDENTIALS_DK=/`basename $PWD`/secret.json
  export GOOGLE_PROJECT=`ggproject`
}
ggudev(){
  unset GOOGLE_CLOUD_PROJECT
  unset GOOGLE_APPLICATION_CREDENTIALS
  unset GOOGLE_APPLICATION_CREDENTIALS_DK
  unset GOOGLE_APPLICATION_CREDENTIALS_DKC
  unset GOOGLE_PROJECT
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
  # TODO: https://source.cloud.google.com/landfill
  # TODO: ?authuser=1 (default)
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
    dp | datap* )
      path=dataproc
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
    gke | k8 | k8s )
      path=kubernetes
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
      path=functions
      ;;
    ae | gae | appe* )
      path=appengine
      ;;
    ps | pub | pubs* )
      path=cloudpubsub
      ;;
    bt | bigt* )
      path=bigtable
      ;;
    span* )
      path=spanner/instances
      ;;
    * )
      path=$1
      ;;
  esac
  open "${base}/${path}?${p}&${oargs}"
}

i-gcloud(){
  tarname='gcloudpkg.tar.gz'
  version='253.0.0'
  url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-linux-x86_64.tar.gz"
  curl -o ${tarname} ${url}
  untar ${tarname} && rm ${tarname}
  rsync -r google-cloud-sdk ~/
  ~/google-cloud-sdk/install.sh
}
