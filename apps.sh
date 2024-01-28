#!/bin/sh
## app installs
#

## Docker ##

# docker - install
i-docker(){
	url='https://github.com/docker/docker-ce/releases/latest'
	tag=`curl -Ls -o /dev/null -w %{url_effective} ${url}`
	tag=${tag##*/}
	version=${tag:1}
	arch=`uname -m`
	[ ${arch} = 'armv7l' ] && arch='armhf'
	zipname=docker-${version}.tgz
	url='https://download.docker.com/linux/static/stable'
	curl -Ls ${url}/${arch}/${zipname} > ${zipname}
	tar -xvzf ${zipname}
	sudo rsync docker/* /usr/bin/
	# create docker group
	sudo groupadd docker
	sudo usermod -aG docker $USER
	rm -rf ${zipname} docker/
	# add systemd scripts for docker deamon
	url='https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/'
	path=/etc/systemd/system
	curl -Ls -O ${url}/docker.service
	curl -Ls -O ${url}/docker.socket
	sudo mv docker.service docker.socket ${path}/
	sudo systemctl enable docker
	sudo systemctl start docker
	[ ${arch} != 'armhf' ] && i-docker-compose
	docker --version
}

# docker compose - install
i-docker-compose(){
	url='https://github.com/docker/compose/releases/latest'
	tag=`curl -Ls -o /dev/null -w %{url_effective} ${url}`
	version=${tag##*/}
	osname=`uname -s`
	arch=`uname -m`
	exname=docker-compose-${osname}-${arch}
	url='https://github.com/docker/compose/releases/download'
	path=/usr/bin
	sudo curl -Ls ${url}/${version}/${exname} > docker-compose
	sudo mv docker-compose ${path}/docker-compose
	sudo chmod +x ${path}/docker-compose
	docker-compose --version
}

## interactive brokers ##

# interactive brokers - install
i-interactivebrokers(){
  url="https://download2.interactivebrokers.com/installers/tws/latest/tws-latest-linux-x64.sh"
  curl -Ls  ${url} > ibtrader.sh
  chmod u+x ibtrader.sh
  ./ibtrader.sh
  rm ibtrader.sh
}

## vpn ##

# expressvpn - install
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
  expressvpn activate
  # cleanup
  rm ${debfile}
  # configure
  expressvpn autoconnect true
  expressvpn preferences set send_diagnostics false
  expressvpn preferences set desktop_notifications false
}

## dev tools ##

# vscode - install
i-vscode(){
  lnk="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  pth="/tmp/vscode.deb"
  curl -Ls ${lnk} > ${pth}
  deb ${pth}
}

## utilities ##

# bitwarden - install
i-bitwarden(){
  url='https://vault.bitwarden.com/download/?app=cli&platform=linux'
  zname='bitwarden.zip'
  xname='bw'
  xpath='/usr/local/bin/'
  curl -Ls ${url} > ${zname}
  unzip ${zname}
  chmod u+x ${xname}
  sudo mv ${xname} ${xpath}
  rm ${zname}
}

# youtubedl - install
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
