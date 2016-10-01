## Function list
# Docker
#
## TODO 
##

# docker run 
#	-d:detach(background) 
#	-i:interactive(kee STDIN open) 
#	-t:throw away container  
#

alias dk='docker'
alias di='dk images'
alias dc='dk ps -a'
alias dl='dk logs'
alias dstats='dk stats'
alias dastats='dk stats --all'
alias dtop='dk top'
alias dport='dk ports'
alias ddiff='dk diff'
alias du='dk pull'
alias dp='dk push'
alias dcm='dk commit'
alias dsearch='dk search'
alias dr='dk run'
alias drd='dr -d'
alias dri='dr -itd'
alias da='dk attach'
alias ds='dk stats'
alias dst='dk stop'
alias dsta='dk stop $(dk ps -a -q)'
alias drst='dk restart'
alias dkk='dk kill'
alias drmc='dk rm'
alias drmca='dk rm $(dk ps -a -q)'
alias drmi='dk rmi'
alias de='dk exec'
alias db='dk build'
alias dip='dk inspect'
alias dcu='docker-compose up'

# run and attach in one command
function dra {
	da $(dri "$@")
}

function ins-docker {
	# download and install docker into '/usr/bin'
	wget 'https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz'
	tar -xvzf docker-latest.tgz
	sudo mv docker/* /usr/bin/
	# create docker group
	sudo groupadd docker
	sudo usermod -aG docker $USER
	rmdir docker-latest.tgz
	# add systemd scripts for docker deamon
	sudo wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service' -P /etc/systemd/system
	sudo wget 'https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket' -P /etc/systemd/system
	sudo systemctl enable docker
	# install docker-compose
	curl -L "https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m`" > docker-compose
	sudo mv docker-compose /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	# verify
	docker --version
	docker-compose --version
}


# cp to rc if behind a proxy for higher-level tools like docker compose
#build_proxy_args="--build-arg http_proxy=http://10.254.12.71:8000 --build-arg #https_proxy=https://10.254.12.71:8000 --build-arg HTTP_PROXY=http://10.254.12.71:8000 --build-arg #HTTPS_PROXY=https://10.254.12.71:8000"
#run_proxy_args="--env http_proxy=http://10.254.12.71:8000 --env #https_proxy=https://10.254.12.71:8000 --env HTTP_PROXY=http://10.254.12.71:8000 --env #HTTPS_PROXY=https://10.254.12.71:8000"

#function docker {
#	if [[ "$1" = "build" ]]; then
#		/usr/bin/docker build $build_proxy_args "${@:2}"
#	elif [[ "$1" = "run" ]]; then
#		/usr/bin/docker run $run_proxy_args "${@:2}"
#	else
#		/usr/bin/docker "${@:1}"
#	fi
#}
