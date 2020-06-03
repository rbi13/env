# clitools

export CLI_SNIP_URL='gs://clitools/snippets'
export CLI_ENV_URL='gs://clitools/envs'
export CLI_LNK_URL='gs://clitools/links'

# links
lnk(){
  if [ -z $1 ]; then
    gsutil ls ${CLI_LNK_URL}
  else
    open `gscat ${CLI_LNK_URL}/$1`
  fi
}
lnkw(){ gswrite ${CLI_LNK_URL}/$1 ;}

# envs
renv(){
  if [ -z $1 ]; then
    gsutil ls ${CLI_ENV_URL}
  else
    source <(gscat ${CLI_ENV_URL}/$1)
  fi
}
renvw(){ gswrite ${CLI_ENV_URL}/$1 ;}

# snippets
snp(){
  if [ -z $1 ]; then
    gsutil ls ${CLI_SNIP_URL}
  else
    gsread ${CLI_SNIP_URL}/$1
  fi
}
snpw(){ gswrite ${CLI_SNIP_URL}/$1 ;}
snpcat(){ gscat ${CLI_SNIP_URL}/$1 ;}
snpd(){ gsutil rm ${CLI_SNIP_URL}/$1 ;}
gsnp(){
  tmp_path="/tmp/${HOME}/" && mkdir -p ${tmp_path}
  context="${tmp_path}/gsnp"
  gsutil cp ${CLI_SNIP_URL}/$1 ${context}
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
