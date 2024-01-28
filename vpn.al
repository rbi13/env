#!/bin/sh

vpnstatus(){
  expressvpn status
  echo 'config...'
  expressvpn preferences
}
vpnon(){ expressvpn connect ;}
vpnoff(){ expressvpn disconnect ;}

