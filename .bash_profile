export src=$GOPATH/src

# Navigation
alias cd='pushd . >> /dev/null;cd'
alias back='popd >> /dev/null'
alias ld='dirs -p | nl -v 0'
alias cls='dirs -c;'
alias ..='pwd;cd ..;pwd;'
alias ...='pwd;cd ../..;pwd;'
alias ....='pwd;cd ../../..;pwd;'
alias .....='pwd;cd ../../../..;pwd;'
alias ll='ls -la'
alias +x='chmod +x'
alias g2='goto'

# Shortcuts
alias src="cd $src"
alias github="cd $src/github.com"
alias gitlab="cd $src/gitlab.com"

# Applications
alias intellij='open -a \"IntelliJ IDEA CE\"'
alias code='open -a \"Visual Studio Code\"'
alias c.='code .'
alias stree='open -a SourceTree'

# Docker cleanup
alias clearcont='docker rm $(docker ps -a -q)'
alias clearimages='docker rmi $(docker images -q)'
alias cld='clearcont;clearimages;docker system prune'

# Docker build / run
alias dc='docker-compose'
alias dcbuild='docker-compose build --no-cache'
alias dcup='docker-compose up'
alias buildup='dcbuild;dcup'
alias dcrun='docker-compose run --rm'
alias burn='buildup;dcrun'
alias drun='docker run -it'

# mkdir and go to it or go to it if already existing
function mkcd() {
  if [ -d "$1" ];
  then 
    cd "$@"
  else 
    mkdir "$@"
    cd "$@"
  fi
}

# go back in navigation history
function b() {
  [ -z "$1" ] && local c=1 || local c=$1
  for((i=1; i<=$c; i++)) 
  do
    back
  done
}

# go to directory that matches search
function goto() {
  local results=`ls -ad *$1*/ | wc -l | awk '{print $1}'`
  local re='^([0-9]+)$'
  if [ $results -eq 0 ]; then
    echo "No matching directory"
  elif [ $results -eq 1 ]; then
    cd `ls -d *$1*/`
  else
    ls -1 -d *$1*/ | nl
    local s=0
    local p="p"
    while [ "$s" != "q" ] && ( ! [[ $s =~ $re ]] || ! [ $s -le $results -a $s -gt 0 ] )
    do
      read s
    done
    [ "$s" != "q" ] && cd `ls -1 -d *$1*/ | sed -n $s$p`
  fi
}

function clone() {
  clone_dir=$(echo $1 | sed "s/.*:\//:\//g" | sed "s/git@/:\/\//g" | sed "s/:\/\///g" | sed "s/:/\//g" | sed "s/.git//g")
  clone_dir="$GOPATH/src/$clone_dir"
  # echo $1
  # echo $clone_dir
  git clone $1 $clone_dir
  cd $clone_dir
}

function origin() {
  git init
  pwd=`pwd`
  path=`echo ${pwd#$src/} | sed 's/\//:/'`
  git remote add origin "git@$path.git"
  if [ ! -z $1 ] && [ $1="push" ]
  then
    git add .
    git commit -m "Initial commit"
    git push -u origin master
  fi
}
