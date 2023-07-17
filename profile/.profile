#!/bin/bash
# .profile
[[ "$0:A" =~ "dotfiles/profile" ]] && SHELL_LIB_DIR=$(dirname $0:A) || SHELL_LIB_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

[ ! -z "$PROFILE_DIR" ] || export PROFILE_DIR=$SHELL_LIB_DIR
export SHELL_LIB_SETTINGS=$(dirname $SHELL_LIB_DIR)/settings

for file in $(ls -1 $SHELL_LIB_DIR | grep -i ".sh$"); do
  source "$SHELL_LIB_DIR/$file";
done;

export PATH="$PATH:$SHELL_LIB_DIR/path"
