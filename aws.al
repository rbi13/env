## Function list
# Amazon Web Services
#
## TODO
##

cli_image='cgswong/aws:latest'

alias nawsconf='sudo nano ~/.aws/config'
alias nawscred='sudo nano ~/.aws/credentials'
alias aaws="dra -v ~/.aws:/root/.aws $cli_image aws"
alias aws="dr -v ~/.aws:/root/.aws $cli_image aws"
