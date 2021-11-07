#!/bin/sh

i-vscode(){
  lnk="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  pth="/tmp/vscode.deb"
  curl -Ls ${lnk} > ${pth}
  deb ${pth}
}
