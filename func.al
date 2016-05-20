# smart cd

## TODO 
# - implement auto-complete
# - implement inference to automatically suggests shortcuts for frequently accessed dirs  
# - implement acd no arg which infers current dir name as shortcut name
# - expand shortcut to other functions mv, cp, etc... by exporting instead of funcion localized lookup 
##

# eval to resolve tilde
cdafile="~/env/cdas"
eval cdafile=$cdafile

# override 'builtin cd' for 'smart cd'
alias cd='scd'
alias lcd='cat $cdafile'
alias nscd='nano $cdafile'

function scd {
	# params
	name=${1%/} # removes trailing slash(for matching) 

	# immidiate dirs take president over shortcuts
	# re-excute command to get ot shortcut
	if [ -d "$name" ]; then builtin cd "$name"; return; fi

	# check cda for shortcut id
	found=$(grep "^$name:" $cdafile)
	# parse out dir OR;
	found=${found/"$name:"/""}
	# set to $1 if not found	
	if [ "$found" == "" ]; then found=$1; fi
	builtin cd $found
}

function acd {
	#params
	#TODO or $2 if specified
	path=$(pwd)
	name=$1
	
	#TODO if [ "$name" == "" ]; then name=lastDirName; fi
	# check cda for shortcut id
	found=$(grep "^$name:" $cdafile)		
	# write or replace shortcut depending if it already exists	
	if [ "$found" == "" ]; then
		echo "$name:$path" >> $cdafile 
	else sed -i '/^name:/c\$name:$path' $cdafile;
	fi
}
