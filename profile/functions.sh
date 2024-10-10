#!/bin/bash
# functions.sh
# generic utility style shell functions

type lib &> /dev/null || alias lib='shell_lib'
alias clean_PATH='export PATH=$(echo $PATH | sed "s# #--|SPACE|--#g" | sed "s#:# #g" | s2l | dedupe | l2s | sed "s# #:#g" | sed "s#--|SPACE|--# #g")'

get_choice() { ## a better select
  local count=`printf "$choice_set" | wc -l | awk '{print $1}'`
  [ ${#choice_set} -eq 0 ] || count=$((count+1))
  local re='^([0-9]+)$'
  if [ $count -eq 0 ]; then
    echo "No match found" && export choice_set=""
  elif [ $count -eq 1 ]; then
    export choice_set="$choice_set"
  else
    printf "$choice_set\n" | nl
    local s=0
    local p="p"
    while [ "$s" != "q" ] && ( ! [[ $s =~ $re ]] || ! [ $s -le $count -a $s -gt 0 ] ) && ! [ -z "$s" ]
    do
      if [[ "$s" =~ [a-zA-Z] ]]; then
        local filtered_choice_set=`printf "$choice_set" | grep -i ".*$s.*"`
        local filtered_count=`printf "$filtered_choice_set" | wc -l | awk '{print $1}'`
        [ ${#filtered_choice_set} -eq 0 ] || filtered_count=$((filtered_count+1))
        [ $filtered_count -gt 1 ] && choice_set="$filtered_choice_set" && count=$filtered_count && printf "$choice_set\n" | nl
        [ $filtered_count -eq 1 ] && choice_set="$filtered_choice_set" && return 0
      fi
      read s
      if [ -z "$s" ]; then s=1; fi;
    done
    [ "$s" != "q" ] && export choice_set="`printf \"$choice_set\" | sed -n $s$p 2>/dev/null`" || export choice_set=""
  fi
}

ckh() { ## clear known hosts
  if [ $# -eq 0 ]
  then
    printf "Enter value to search for and remove from known_hosts: "
    read search
  else
    search=$1
  fi
  sed -i '' "/$search/d" ~/.ssh/known_hosts
}

source_env() {
  set -a && source $1 && set +a
  #source <(sed -E -n 's/[^#]+/export &/ p' "$1")
}

close() { ## close ports
  export choice_set=`ports | grep -i ".*$1.*" | awk '{pid=$2;$2="";print pid " " $0}'`
  get_choice
  echo $choice_set
  [ "$choice_set" != "" ] && kill -9 `echo $choice_set | sed -E -e "s/[[:blank:]]+/ /g" | awk '{print $1}'`
}

type s2l &> /dev/null || alias s2l='space_to_line'
space_to_line() {
  read data;
  for element in $(echo "$data"); do
    echo "$element";
  done;
}

type l2s &> /dev/null || alias l2s='line_to_space'
line_to_space() {
  output="";
  while read data; do
    output="$output $data"
  done;
  echo $output | sed 's/^ //'
}

dedupe() { ## remove duplicate lines, preserves order
  local SEPARATOR="DUPE_SEPARATOR"
  local values="$SEPARATOR"
  while read data; do
    echo "$values" | grep "$SEPARATOR$data$SEPARATOR" > /dev/null || echo "$data";
    values="$values$data$SEPARATOR";
  done;
}

shell_lib() { ## list shell library functions (alias: lib)
  local ld=$SHELL_LIB_DIR;
  local pattern='().*{.*[#][#]';
  local shell_lib=$(awk '{print FILENAME, $0}' $ld/*.sh | sed "s#$ld/##g");
  local all_aliases=$(alias | grep -v "[ ;]" );
  if [ $SHELL_LIB_DIR != $PROFILE_DIR ]; then
    ld=$PROFILE_DIR;
    shell_lib=$(awk '{print FILENAME, $0}' $ld/*.sh | sed "s#$ld/##g")"\n$shell_lib";
  fi
  echo "$shell_lib" | grep $pattern | sed "s/$pattern/ /g" | \
  sed 's/\([^\s-]*\).sh/\1/' | \
  awk '{file=$1;$1="";cmd=$2;$2="";printf "\033[92m%-12s \033[96m%25s\033[0m %s\n", file, cmd, $0}';
}

alias dts='timestamp'
timestamp() { ## list shell library functions (alias: dts)
  date
  time $@
  date
}
