## Function list
# System calls and information
#  
## TODO 
##

alias ctl='sudo systemctl'
alias kernel-version='uname -mrs'
alias distro-info='cat /etc/*-release'
alias distro-base='lsb_release -a'
alias poweroff='sudo shutdown -h now'

# clipboard
alias cbcopy='xclip -selection c'
alias cbpaste='xclip -selection clipboard -o'

# ssh
alias skeys='ls -al ~/.ssh'
alias sgen='ssh-keygen -t rsa -b 4096 -C'
scat() { 
	[[ -z "$1" ]] && key=~/.ssh/id_rsa.pub || key=~/.ssh/$1.pub 
	cat $key | cbcopy
	cat $key
}
# TODO: add command for public key distribution
# ssh-keygen -t rsa
# cat ~/.ssh/id_rsa.pub | ssh user@hostname 'cat >> .ssh/authorized_keys'

# package managers
alias sag='sudo apt-get'
