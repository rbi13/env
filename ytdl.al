#!/bin/sh

i-youtubedl(){
  # install
  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl \
    -o /usr/local/bin/youtube-dl
  sudo chmod a+rx /usr/local/bin/youtube-dl

  # verify
  sudo wget https://yt-dl.org/downloads/latest/youtube-dl.sig -O youtube-dl.sig
  gpg --verify youtube-dl.sig /usr/local/bin/youtube-dl
  rm youtube-dl.sig
}

ytdl(){
  [ -z  $1 ] && vlnk=$(cbpaste) || vlnk=$1
  youtube-dl --write-auto-sub --skip-download ${vlnk}
}
