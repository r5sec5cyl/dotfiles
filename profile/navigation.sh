# navigation.sh
alias cd='pushd . >> /dev/null;cd'
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

# mkdir and go to it or go to it if already existing
mkd() {
  if [ ! -d "$1" ];
  then
    mkdir "$@"
  fi
  cd "$@"
}

# go back in navigation history
b() {
  [ -z "$1" ] && local c=1 || local c=$1
  for ((i=1; i<=$c; i++))
  do
    back
  done
}

revisit() {
  export choice_set=`dirs -p | grep -i ".*$1.*"`
  get_choice
  [ "$choice_set" != "" ] && eval "cd $choice_set"
}

# go to directory that matches search
goto() {
  export choice_set=`ls -AF1 | grep "/" | grep -i ".*$1.*"` #ls -ad *$1*/ 2>/dev/null
  get_choice
  [ "$choice_set" != "" ] && cd "$choice_set"
}

go_deep() {
  export choice_set=`find . -type d | grep -i ".*$1.*"`
  get_choice $@
  [ "$choice_set" != "" ] && cd "$choice_set"
}

go_find() {
  export choice_set=`find . | grep -i ".*$1.*"`
  get_choice $1
  [ "$choice_set" != "" ] && ([ ! -z $2 ] && cd $(dirname "$choice_set") || eval "$2$choice_set$3")
}
