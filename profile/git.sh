# git.sh
alias bro='browse'
alias forcepush='git push origin `git rev-parse --abbrev-ref HEAD` --force'
alias fp=forcepush

alias or='open_repo'
alias tt='newtab open_repo'

repo_info() {
  dir=`pwd`
  [[ $dir != *"$DEVPATH/src/"* ]] && export git_local_path="." && return 1
  current_path=`echo ${dir#$DEVPATH/src}`
  count=$(echo "${current_path}" | awk -F"/" '{print NF-1}')
  export git_path=""
  [ $count -ge 1 ] && export git_domain=$(echo $current_path | cut -d'/' -f2) && git_path=$git_domain || export git_domain=""
  [ $count -ge 2 ] && export git_org=$(echo $current_path | cut -d'/' -f3) && git_path="$git_path/$git_org" || export git_org=""
  [ $count -ge 3 ] && export git_repo=$(echo $current_path | cut -d'/' -f4) && git_path="$git_path/$git_repo" || export git_repo=""
  export git_tree=`echo ${dir#$DEVPATH/src/$git_domain/$git_org/$git_repo/}`
  export git_local_path="$DEVPATH/src/$git_path"
  [ $git_tree != $dir ] || export git_tree=""
  [ ! -z $git_repo ] && export git_branch=`git rev-parse --abbrev-ref HEAD`

  if [ "-s" != "$1" ] ;
  then
    echo "domain (git_domain):  $git_domain"
    echo "org (git_org):  $git_org"
    echo "repo (git_repo):  $git_repo"
    echo "tree (git_tree):  $git_tree"
    echo "branch (git_branch):  $git_branch"
  fi
}

clone() {
  repo=$1
  if [[ $repo != *"/"* ]] ; then
    repo_info -s || (echo "no repo found" && return 1)
    repo="git@$git_domain:$git_org/$repo.git"
  fi
  echo $repo
  clone_dir=$(echo $repo | sed "s/.*:\//:\//g" | sed "s/git@/:\/\//g" | sed "s/:\/\///g" | sed "s/:/\//g" | sed "s/\.git//g")
  clone_dir="$DEVPATH/src/$clone_dir"
  git clone $repo $clone_dir
  cd $clone_dir
}

origin() {
  git init
  repo_info -s || (echo "no repo found" && return 1)
  repo="git@$git_domain:$git_org/$git_repo.git"
  git remote add origin $repo
  if [ ! -z $1 ] && [ $1="push" ]
  then
    git add .
    git commit -m "Initial commit"
    git push -u origin master
  fi
}

open_repo() {
  repo_info -s
  cd "$DEVPATH/src/$git_domain/$git_org/$1" 2>/dev/null
  if [ $? -ne 0 ]; then
    cd "$DEVPATH/src/$git_domain/$git_org/"
    goto "$1"
  fi
}

browse() {
  repo_info -s || (echo "no repo found" && return 1)
  current_path="$git_domain/$git_org/$git_repo"
  [ ! -z $git_tree ] && [ $git_tree != "" ] && current_path="$current_path/tree/$git_branch/$git_tree" && [ ! -z $1 ] && current_path="$current_path/$1"
  open -a "Google Chrome" "http://$current_path"
}

st() {
  repo_info -s || (echo "no repo found" && return 1)
  stree "$DEVPATH/src/$git_path"
}

base() {
  repo_info -s || (echo "no repo found" && return 1)
  cd "$DEVPATH/src/$git_path"
}
