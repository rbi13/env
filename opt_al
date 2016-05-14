export opt_root='/opt'

# launchers
alias teli='$opt_root/teli/cur/bin/idea.sh'
alias java='$opt_root/java/cur/bin/java'

#functions

# make a public directory for a new app in opt_root 
function mkdiropt {
	sudo mkdir -p $opt_root/$1
	sudo chmod a+rw $opt_root/$1
	cd $opt_root/$1
}

# switch version of an opp i opt_root
function verset {
	ln -nfs $1 cur
}
