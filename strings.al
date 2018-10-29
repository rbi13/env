#!/bin/bash

## String and file manipulations
#
# sed functions combined with ';'
#

alias xclip="xclip -selection c"

function sstrip {
	sed "s/$1//g" $2
}

function sappend {
	sed "s/\$/$1/" $2
}

function sprepend {
	sed "s/^/$1/" $2
}
