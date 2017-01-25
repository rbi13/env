#!/bin/sh
## Function list
# - scd: 'bookmarking/aliasing' (with acd) directories to jump to them by name. Note the 'scd' command ovverides 'cd'
# - deb: manual installation of '.deb' files
# - untar: single command to handle decompressing of zips and tars
#
## TODO
# - FIXME: 'acd overwrite' not posix
# - implement acdp (public) to differentiate between ~/ and ~/env shortcuts
# - implement auto-complete
# - implement inference to automatically suggests shortcuts for frequently accessed dirs
# - implement acd no arg which infers current dir name as shortcut name
# - expand shortcut to other functions mv, cp, etc... by exporting instead of funcion localized lookup
##

expect_image='mesosphere/alpine-expect'
alias expect='drc \
  -v `pwd`:`pwd` -w `pwd` \
  $expect_image expect'

# eval to resolve tilde
cdafile="~/env/cdas"
eval cdafile=$cdafile

# override 'builtin cd' for 'smart cd'
alias cd='scd'
alias lcd='cat $cdafile'
alias ncd='nano $cdafile'
scd(){
  # params
  name=${1%/} # removes trailing slash(for matching)

  # immidiate dirs take president over shortcuts
  # re-excute command to get ot shortcut
  if [ -d "$name" ]; then builtin cd "$name"; return; fi

  # check cda for shortcut id
  found=$(grep "^$name:" $cdafile)
  # parse out dir OR;
  found=${found/"$name:"/""}
  # set to $1 if not found
  if [ "$found" == "" ]; then found=$1; fi
  eval "builtin cd $found"
}
acd(){
  #params
  #TODO or $2 if specified
  path=$("dirs")
  name=$1

  #TODO if [ "$name" == "" ]; then name=lastDirName; fi
  # check cda for shortcut id
  found=$(grep "^$name:" $cdafile)
  # write or replace shortcut depending if it already exists
  if [ "$found" == "" ]; then
    echo "$name:$path" >> $cdafile
	# includes 'colon' for full tag match
  else sed -i "/^$name:/c$name:$path" $cdafile;
  fi
}

## other functions

# install from deb files
deb(){
  # abort on any error
  # eval to resolve
  eval debFile=$1
  # validate file
  if [ -f "$debFile" ]; then
    # dpkg and install, return on failure
    sudo dpkg -i $debFile || return;
    sudo apt-get install -f
  else echo "'$debFile' does not exist";
  fi
}

# untar to an (optional) destination
untar(){
  archive="$1"
  dest="$2"
  # zip files
  if [ "$archive" == *.zip ]; then
    if [ -z "$dest" ]; then
      unzip $archive
    else
      mkdir -p $dest
      unzip $archive -d $dest
    fi
  # tar files
  else
    if [ -z "$dest" ]; then
      [[ "$archive" == *bz2 ]] && tar vxjf $archive || tar -zxf $archive
    else
      mkdir -p $dest
      [[ "$archive" == *bz2 ]] && tar vxjf $archive || tar -zxf $archive -C $dest
      tar -zxf $archive -C $dest
    fi
  fi
}


# file and string manipulation
to_csv(){
  libreoffice --headless --convert-to csv "$1"
}
