## Function list
# Docker
#
## TODO 
##

alias dk='docker'
alias du='dk pull'
alias dp='dk push'
alias dr='dk restart'
alias dkk='dk kill'
alias drc='dk rm'
alias dri='dk rmi'

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
	rmdir docker
	# add systemd scripts for docker deamon
	sudo wget https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service -P /etc/systemd/system
	sudo wget https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket -P /etc/systemd/system
	sudo systemctl enable docker
}
