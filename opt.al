# environment variables
export opt_root='/opt'
export SCALA_HOME="$opt_root/scala/cur"
#export JAVA_HOME="$opt_root/java/cur"
export GRADLE_HOME="$opt_root/gradle/cur"

# launchers
alias atom='$opt_root/atom/cur/atom'
alias sublime='$opt_root/sublime/cur/sublime_text'
alias teli='$opt_root/teli/cur/bin/idea.sh &'
alias charm='$opt_root/pycharm/cur/bin/pycharm.sh &'
alias eclipse='$opt_root/eclipse/cur/eclipse &'
alias java='$JAVA_HOME/bin/java'
alias scala="$SCALA_HOME/bin/scala"
alias gradle='$GRADLE_HOME/bin/gradle'
#alias gradle='drn frekele/gradle pwd'
alias gr='gradle'
alias squirrel='java -jar $opt_root/squirrel/cur/squirrel-sql.jar'

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

# links
# pandoc
# https://github.com/jgm/pandoc/releases/download/1.17.2/pandoc-1.17.2-1-amd64.deb
