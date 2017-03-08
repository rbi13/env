## Function list
# Amazon Web Services
#
## TODO
##

cli_image='rbi13/awscli'

awss(){ dh ${cli_image} aws ${@:1} ;}

alias nawsconf='sudo nano ~/.aws/config'
alias nawscred='sudo nano ~/.aws/credentials'
alias aaws="dh $cli_image"
alias taws='drc \
        -v ~/.aws:/root/.aws \
        -v `pwd`:`pwd` -w `pwd` \
        $cli_image'

# cloud formation
alias cf='aws cloudformation'
alias cfl='cf list-stacks'
alias cflr='cf list-stack-resources --stack-name'
