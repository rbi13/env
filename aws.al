## Function list
# Amazon Web Services
#
## TODO
##

cli_image='cgswong/aws:latest'

alias nawsconf='sudo nano ~/.aws/config'
alias nawscred='sudo nano ~/.aws/credentials'
alias aaws="dra -v ~/.aws:/root/.aws $cli_image"
alias aws='drc \
	-v ~/.aws:/root/.aws \
	-v `pwd`:`pwd` -w `pwd` \
	$cli_image aws'
alias taws='drc \
        -v ~/.aws:/root/.aws \
        -v `pwd`:`pwd` -w `pwd` \
        $cli_image'

# cloud formation
alias cf='aws cloudformation'
alias cfl='cf list-stacks'
alias cflr='cf list-stack-resources --stack-name'
