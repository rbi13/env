export opt_root='/opt'

# launchers
alias teli='$opt_root/teli/cur/bin/idea.sh &'
alias eclipse='$opt_root/eclipse/cur/eclipse &'
alias java='$opt_root/java/cur/bin/java'
alias gr='$opt_root/gradle/cur/bin/gradle'

# extras
# gradle-deamon
touch ~/.gradle/gradle.properties && echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties

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
