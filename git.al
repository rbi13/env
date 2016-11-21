# git alias
alias gcl='git clone'
alias ga='git add'
alias gaa='git add .'
alias gs='git status'
alias gc='git commit -m'
alias gac='gaa; gc'
alias gp='git push -u origin'
alias gpm='git push origin master'
alias gpi='git push internal master'
alias gpmi='gpm; gpi;'
alias gu='git pull origin'
alias gui='git pull internal'
alias gum='git pull origin master'
alias gk='git checkout'
alias gkb='git checkout -b'
alias gkk='git checkout --'
alias gt='git stash'
alias gta='git stash apply'
alias gl='git log --oneline --abbrev-commit --all --graph --decorate --color'
alias gd='git diff --color'
alias grh='git reset --hard'
alias gbv='git branch -v -a'
alias gbd='git branch -D'
alias grv='git remote -v'
alias gf='git fetch'
alias gclean='git remote prune origin'

gsa(){ git subtree add --prefix $2 $1 master --squash; }
gsu(){ git subtree pull --prefix $2 $1 master --squash; }
# TODO: add subtree url tracking

# PS1 prompt (shows branch on git dirs)
[ -f /etc/bash_completion.d/git-prompt  ] && source /etc/bash_completion.d/git-prompt

# functions

# github
github_create(){
	repo_name="$1"
	curl -u $(mapget github_user) https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"
}
github_clone(){
	gcl "git@github.com:$(mapget github_user)/$1.git"
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
