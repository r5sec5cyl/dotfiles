#!/bin/bash
# git.sh
alias bro='browse'
alias forcepush='git push origin `git rev-parse --abbrev-ref HEAD` --force'
alias fp=forcepush

alias or='open_repo'
alias tt='newtab open_repo'

alias upstream='git upstream'

repo_info() { ## details of a repo; defaults to git info, uses path as backup
  git status > /dev/null 2>&1 && git rev-parse --abbrev-ref HEAD > /dev/null 2>&1 && is_git=1 || is_git=0
  if [ "$is_git" -gt 0 ] ; then
    export git_origin=$(git ls-remote --get-url)
    export git_local_path=$(git rev-parse --show-toplevel)
    local parts=$(echo $git_origin | sed 's#.git$##g' | sed 's#[@/:]# #g')
    export git_domain=$(awk '{print $2}' <<< $parts)
    export git_org=$(awk '{print $3}' <<< $parts)
    export git_repo=$(awk '{print $4}' <<< $parts)
    pwd=`pwd`
    export git_tree=$(echo ${pwd#$git_local_path})
    export git_branch=$(git rev-parse --abbrev-ref HEAD)
  else
    repo_info_path_based -s
  fi

  if ! contains_flag -s "$@" ; then
    local output_format="${YELLOW}%-17s${LT_GREEN}%7s:${DEFAULT_FMT} %s\n"
    printf "$output_format" "(git_origin)" "origin" "$git_origin"
    printf "$output_format" "(git_local_path)" "path" "$git_local_path"
    printf "$output_format" "(git_domain)" "domain" "$git_domain"
    printf "$output_format" "(git_org)" "org" "$git_org"
    printf "$output_format" "(git_repo)" "repo" "$git_repo"
    printf "$output_format" "(git_tree)" "tree" "$git_tree"
    printf "$output_format" "(git_branch)" "branch" "$git_branch"
  fi
}

repo_info_path_based() { ## details of a repo based on path
  dir=`pwd`
  [[ $dir != *"$DEVPATH/src/"* ]] && export git_local_path="." && return 1
  current_path=`echo ${dir#$DEVPATH/src}`
  count=$(echo "${current_path}" | awk -F"/" '{print NF-1}')
  export git_path=""
  [ $count -ge 1 ] && export git_domain=$(echo $current_path | cut -d'/' -f2) && git_path=$git_domain || export git_domain=""
  [ $count -ge 2 ] && export git_org=$(echo $current_path | cut -d'/' -f3) && git_path="$git_path/$git_org" || export git_org=""
  [ $count -ge 3 ] && export git_repo=$(echo $current_path | cut -d'/' -f4) && git_path="$git_path/$git_repo" || export git_repo=""
  export git_tree=`echo ${dir#$DEVPATH/src/$git_domain/$git_org/$git_repo}`
  export git_local_path="$DEVPATH/src/$git_path"
  [ "$git_tree" != "$dir" ] || export git_tree=""
  [ ! -z $git_repo ] && export git_branch=`git rev-parse --abbrev-ref HEAD`

  if ! contains_flag -s "$@" ; then
    local output_format="${YELLOW}%-17s${LT_GREEN}%7s:${DEFAULT_FMT} %s\n"
    printf "$output_format" "(git_local_path)" "path" "$git_local_path"
    printf "$output_format" "(git_domain)" "domain" "$git_domain"
    printf "$output_format" "(git_org)" "org" "$git_org"
    printf "$output_format" "(git_repo)" "repo" "$git_repo"
    printf "$output_format" "(git_tree)" "tree" "$git_tree"
    printf "$output_format" "(git_branch)" "branch" "$git_branch"
  fi
}

clone() { ## clones a git repo into appropriate directory
  repo=$1
  sepcount=$(sed "s/[^:\/@]//g" <<< "$repo" | wc -m)
  if [[ $sepcount -le 2 ]] ; then
    repo_info -s || (echo "no repo found" && return 1)
    if [[ $repo != *"/"* ]] ; then
      repo="git@$git_domain:$git_org/$repo.git"
    else
      org=$(cut -d/ -f1 <<< "$repo")
      project=$(cut -d/ -f2 <<< "$repo")
      repo="git@$git_domain:$org/$project.git"
    fi
  fi
  echo $repo
  clone_dir=$(echo $repo | sed "s/.*:\//:\//g" | sed "s/git@/:\/\//g" | sed "s/:\/\///g" | sed "s/:/\//g" | sed "s/\.git//g")
  clone_dir="$DEVPATH/src/$clone_dir"
  git clone $repo $clone_dir
  cd $clone_dir
}

origin() { ## sets origin remote of git repo
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

open_repo() { ## opens another repo in same org (alias: or)
  repo_info -s
  cd "$DEVPATH/src/$git_domain/$git_org/$1" 2>/dev/null
  if [ $? -ne 0 ]; then
    cd "$DEVPATH/src/$git_domain/$git_org/"
    goto "$1"
  fi
}

browse() { ## opens the repo (or org) in Chrome (alias: bro)
  repo_info -s || (echo "no repo found" && return 1)
  current_path="$git_domain/$git_org/$git_repo"
  [ ! -z $git_tree ] && [ $git_tree != "" ] && current_path="$current_path/tree/$git_branch$git_tree" && [ ! -z $1 ] && current_path="$current_path/$1"
  open -a "Google Chrome" "http://$current_path"
}

st() { ## opens repo in SourceTree
  repo_info -s || (echo "no repo found" && return 1)
  stree "$git_local_path"
}

base() { ## return to the base directory of the repo
  repo_info -s || (echo "no repo found" && return 1)
  cd "$git_local_path"
}
