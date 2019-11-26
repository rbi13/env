#!/bin/bash
# git alias
alias gcl='git clone'
alias gs='git status'
ga(){ git add ${@:1} ;}
gaa(){ git add . ${@:1} ;}
gc(){ git commit -m "${@:1}" ;}
gaac(){ gaa; gc "$1" ;}
gaacp(){ gaac "$1" && gpc ;}
gac(){ ga ${@:2} && gc "$1" ;}
alias gp='git push -u origin'
alias gpu='git push -u upstream'
gpc(){ gp $(gbc) ;}
alias gpm='git push origin master'
alias gpi='git push internal master'
alias gpmi='gpm; gpi;'
alias gu='git pull origin'
alias gui='git pull internal'
alias gum='git pull origin master'
alias gk='git checkout'
alias gkb='git checkout -b'
gkbp(){ gkb $1 && gp $(gbc) ;}
alias gkk='git checkout --'
alias gt='git stash'
alias gtl='git stash list'
alias gta='git stash apply'
alias grm='git reset HEAD --'
gtai(){ git stash apply "stash@{$1}" ;}
alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
gd(){ git diff --color ${@:1} ;}
gdc(){ git show $1 ;}
gdf(){ git show --name-only $1 ;}
gdff(){ git show $1:$2 ;}
alias gdl='gd HEAD^ HEAD'
alias grh='git reset --hard'
alias grhh='grh && git clean -dfx'
alias gb='git branch'
alias gbv='git branch -v -a && gtag'
alias gbd='git branch -D'
gbdr(){ git branch -D $1 && git push -d origin $1 ;}
alias grv='git remote -v'
alias gbc='git rev-parse --abbrev-ref HEAD'
alias gf='git fetch'
alias gm='git merge'
alias gcherry='git cherry-pick'
alias gfp='gf --prune'
alias gclean='git remote prune origin'
alias ginfo='git log --diff-filter=A --'
gtag(){ git tag ${@:1} ;}
gptag(){ gtag ${@:1}; gp ${@:1} ;}
glast-commit(){ git log -1 --format="%ad" ${@:1} ;}

# subtree
# TODO: add subtree url tracking
gsub(){
	[ -z $3 ] && ref='master' || ref=$3
	git subtree add --prefix $1 $2 ${ref} --squash
}
gsubup(){
	[ -z $3 ] && ref='master' || ref=$3
	git subtree pull --prefix $1 $2 ${ref}
}

# PS1 prompt (shows branch on git dirs)
[ -f /etc/bash_completion.d/git-prompt  ] && source /etc/bash_completion.d/git-prompt

# functions

# github
github-create(){
	repo_name="$1"
	curl -u $(mapget github_user) https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"
}
github-clone(){
	echo "git@github.com:$(mapget github_user)/$1.git"
	gcl "git@github.com:$(mapget github_user)/$1.git"
}
gi(){
	if [ -z $2 ]; then
		curl -s https://www.gitignore.io/api/$1 | cbcopy
	else
		curl -s https://www.gitignore.io/api/$1 >> $2
	fi
}

github(){
	base='https://github.com'
	[ -z $1 ] && url=${base}/rbi13/env || url=${base}/search?q=$1
	open ${url}
}

github-raw(){
	[ -z $1 ] && url=$(cbpaste) || url=$1
	converted=$(echo ${url} | sed "s/github.com/raw.githubusercontent.com/g" | sed "s/\/blob\//\//g")
	curl -s ${converted} | cbcopy
}

# generate gitignore files using templates
#function gi {
# clone gitingore project if not already present (this folder should be added to env/.gitignore)
## git clone --depth 1 git@github.com:github/gitignore.git

# accept 'types' as arguments 'gi java gradle ...'

# look these up in the current gitignore file
## (use awk to list types used in current file 'gi java gradle')

# grab the content from the gitignore/ project for types missing from the previous step

# insert content into gitignore file and updated 'gi ...' line (use sed)

# future: potentially infer types;  have a refresh method
#}
