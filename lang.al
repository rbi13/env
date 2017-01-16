#!/bin/sh
## Function list
# System calls and information
#
## TODO
##

go_img='golang'

go(){ drip ${go_img} go ${@:1} ;}
gor(){ go run ${@:1} ;}
