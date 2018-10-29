#!/bin/bash

go_img='golang'

gol(){
  dri \
    -e GOPATH=/go\
    -v ~/ws/go:/go -v ~/:/root/\
    -w /go$(pwd | awk -F "$USER/ws/go" '{print $2}')\
    ${go_img} ${@:1}
}

goi(){ go install ${@:1} ;}
god(){ go godep ${@:1} ;}
gor(){ go run ${@:1} ;}
goe(){ go $(basename $PWD) ${@:1} ;}
gobd(){ go build ${@:1} ;}
gobdsl(){ gobd -o $1.so -buildmode=c-shared $1.go ;}
gogt(){ go get ${@:1} ;}
got(){ go test ${@:1} ;}

golb(){ gol /bin/bash ;}
golg(){ gol go ${@:1} ;}
goli(){ golg install ${@:1} ;}
gold(){ golg godep ${@:1} ;}
golr(){ golg run ${@:1} ;}
gole(){ gol $(basename $PWD) ${@:1} ;}
golbd(){ golg build ${@:1} ;}
golbdsl(){ golbd -o $1.so -buildmode=c-shared $1.go ;}
golgt(){ golg get ${@:1} ;}
golt(){ golg test ${@:1} ;}
