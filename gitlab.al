#!/bin/bash

gitlab(){
external_url='gitlab.example.com'
  dr --detach \
    --hostname  ${external_url}\
    --env GITLAB_OMNIBUS_CONFIG="external_url 'http://${external_url}/'; gitlab_rails['lfs_enabled'] = true;" \
    --publish 443:443 --publish 80:80 --publish 23:22 \
    --name gitlab \
    --restart always \
    --volume ~/.gitlab/config:/etc/gitlab \
    --volume ~/.gitlab/logs:/var/log/gitlab \
    --volume ~/.gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
}

gitlabb(){ sudo docker exec -it gitlab /bin/bash ;}

gitlabcurl(){
  curl\
    --request GET\
    --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}"\
    'http://gitlab.example.com/api/v4/projects?perpage=100'
    # 'http://gitlab.example.com/api/v4/projects/:id/repository/tree'
}
