#!/bin/sh
#
# Docker
#
#

i-docker(){
	#[[ -z $1 ]] && version='latest' || version=$1
	# download and install docker into '/usr/bin'
	tag=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/docker/docker-ce/releases/latest`
	tag=${tag##*/}
	version=${tag:1}
	wget "https://download.docker.com/linux/static/stable/x86_64/docker-${version}.tgz"
	tar -xvzf docker-${version}.tgz
	sudo rsync docker/* /usr/bin/
	# create docker group
	sudo groupadd docker
	sudo usermod -aG docker $USER
	rm docker-${version}.tgz
	rm -rf docker/
	# add systemd scripts for docker deamon
	wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service'
	wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket'
	sudo mv docker.service docker.socket /etc/systemd/system/
	sudo systemctl enable docker
	sudo systemctl start docker
	# install docker-compose
	i-docker-compose
	# verify
	docker --version
	docker-compose --version
}

i-docker-compose(){
	tag=`curl -Ls -o /dev/null -w %{url_effective} https://github.com/docker/compose/releases/latest`
	tag=${tag##*/}
	curl -L "https://github.com/docker/compose/releases/download/${tag}/docker-compose-`uname -s`-`uname -m`" > docker-compose
	sudo mv docker-compose /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
}


# docker
alias d="docker"

# docker-compose up
alias dcu="docker-compose up"

# docker-compose up detached
alias dcud="dcu -d"

# docker-compose up --build
alias dcub="dcu --build"

# docker-compose up --build detached
alias dcubd="dcub -d"

# docker-compose down
alias dcd="docker-compose down"

# docker build
alias db="docker build"

# docker build tag
alias dbt="db . -t"

# docker run and cleanup
alias dr="docker run --rm"

# Run Bash on Docker-Compose Service { serviceName }
dbash(){
	docker-compose exec $1 /bin/bash
}

# Run sh on Docker-Compose Service { serviceName }
dsh(){
	docker-compose exec $1 /bin/sh
}