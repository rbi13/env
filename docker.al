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
alias di='dk imagesnrc'
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
alias ds='dk start'
alias dst='dk stop'
alias dsta='dk stop $(dk ps -a -q)'
alias drst='dk restart'
alias dkk='dk kill'
alias drmc='dk rm'
alias drmca='dk rm $(dk ps -a -q)'
alias drmi='dk rmi'
alias de='dk exec'
alias db='dk build'

# run and attach in one command
function dra {
	da $(dri $1)
}

# NOTE: 
# - deamon does not work (fails on docker.socket). TODO: try creating user group 'docker'.
# - user has to be added to docker group: 'sudo usermod -aG docker <user>'
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


