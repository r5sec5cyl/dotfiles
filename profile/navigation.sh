#!/bin/bash
# navigation.sh
alias back='popd >> /dev/null'
alias ld='dirs -p | nl -v 0'
alias rv='revisit'
alias cls='newtab;exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ll='pwd;ls -la'
alias xx='chmod +x'
alias g2='goto'
alias gd='go_deep'
alias gf='go_find'

export src=$DEVPATH/src
export github=$src/github.com
export gitlab=$src/gitlab.com

alias github="cd $github"
alias gitlab="cd $gitlab"

cd() {
  pushd . >> /dev/null;
  builtin cd "$@";
}

newtab() {
  if [[ "$OSTYPE" =~ "darwin" ]]; then
    osascript -e 'tell application "Terminal" to activate' -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down'
    if [ $# -gt 0 ]; then
      cmd="tell application \"Terminal\" to do script \"$@\" in front window"
      osascript \
        -e "tell application \"Terminal\" to activate" \
        -e "$cmd" &> /dev/null
    fi
  else
    echo "newtab currently only valid for macos"
  fi
}

mkd() { ## mkdir and go to it or go to it if already existing
  [ -d "$1" ] || mkdir "$@"
  cd "$1"
}

b() { ## go back in navigation history n times (n defaults to 1)
  [ -z "$1" ] && local c=1 || local c=$1
  for ((i=1; i<=$c; i++)); do
    back
  done
}

revisit() { ## navigate to directory from navigation history (alias rv)
  export choice_set=`dirs -p | grep -i ".*$1.*"`
  get_choice
  [ "$choice_set" != "" ] && eval "cd $choice_set"
}

goto() { ## go to directory that matches search (alias g2) (max one level deep)
  export choice_set=`ls -AF1 | grep "/" | grep -i ".*$1.*"` #ls -ad *$1*/ 2>/dev/null
  get_choice
  [ "$choice_set" != "" ] && cd "$choice_set"
}

go_deep() { ## go to directory that matches search any number of levels deep (alias gd)
  export choice_set=`find . -type d | grep -i ".*$1.*"`
  get_choice $@
  [ "$choice_set" != "" ] && cd "$choice_set"
}

go_find() { ## match a file any number of levels deep (alias gf)
  export choice_set=`find . | grep -i ".*$1.*"`
  get_choice $1
  [ "$choice_set" != "" ] && ([ ! -z $2 ] && cd $(dirname "$choice_set") || eval "$2$choice_set$3")
}
