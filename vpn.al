#!/bin/sh

vpnstatus(){
  expressvpn status
  echo 'config...'
  expressvpn preferences
}
vpnon(){ expressvpn connect ;}
vpnoff(){ expressvpn disconnect ;}

i-expressvpn(){
  # configure-download
  url='https://download.expressvpn.xyz/clients/linux'
  version='2.5.0.505-1'
  arch=`uname -m`
	[ ${arch} = 'armv7l' ] && arch='armhf' || arch='amd64'
  name=expressvpn_${version}_${arch}.deb
  signame=${name}.asc
  # download
  sig=`curl ${url}/${signame}`
  debfile=expressvpn.deb
  curl -Ls ${url}/${name} > ${debfile}
  # install
  deb ${debfile}
  # activation
  renv expressvpn
  echo ${EXPRESSVPN_ACTIVATION} | cbcopy
  expressvpn activate
  # cleanup
  echo '' | cbcopy
  unset EXPRESSVPN_ACTIVATION
  rm ${debfile}
  # configure
  expressvpn autoconnect true
  expressvpn preferences set send_diagnostics false
  expressvpn preferences set desktop_notifications false
}
