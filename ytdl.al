#!/bin/sh


ytdl(){
  [ -z  $1 ] && vlnk=$(cbpaste) || vlnk=$1
  youtube-dl --write-auto-sub --skip-download ${vlnk}
}
