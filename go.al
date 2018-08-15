#== golang
GOPATH="${HOME}/ws/go"
go_img='golang'



# mount GOPATH and set workdir (current)
# go_b(){
#   dri \
#     -v ${GOPATH}:/go \
#     -w "/go$(pwd | awk -F 'go' '{print $2}')" \
#     ${go_img} ${@:1}
# }
# go(){ go_b go ${@:1} ;}
# gor(){ go run ${@:1} ;}
# godep(){ go_b godep ${@:1} ;}
