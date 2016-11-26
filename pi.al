#!/bin/bash
#
# rpi stuff 
#
#

# write to sd card: img disk 
function imgwrite { sudo dd bs=4M status=progress if="$1" of="$2"; sudo sync ;}
# clone image from card: img disk 
function imgclone { sudo dd bs=4M status=progress if="$2" of="$1"; sudo sync ;}


