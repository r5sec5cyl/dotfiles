# python.sh
pipup() {
  curl https://bootstrap.pypa.io/get-pip.py | python
}

venv() {
  cd ~/envs
  export choice_set=`ls -ad *$1*`
  back
  get_choice $@
  [ "$choice_set" != "" ] && ([[ "$VIRTUAL_ENV" != *"/"* ]] || deactivate) && source "$HOME/envs/$choice_set/bin/activate"
}

new_venv() {
  local name="${@: -1}"
  local params=$@
  [ -z $1 ] && echo "please provide virtual env name" && read name
  [ -z $name ] && name=$(basename "$PWD")
  params=${@:1:$#-1}
  virtualenv $params $HOME/envs/$name
  cp "$HOME/envs/default/pip.conf" "$HOME/envs/$name/pip.conf"
  xx $HOME/envs/$name/bin/*
  xx $HOME/envs/$name/*
  venv "$name"
}

venv2() {
  local name="${@: -1}"
  local params=$@
  [ -z $1 ] && echo "please provide virtual env name" && read name
  [ -z $name ] && name=$(basename "$PWD")
  params=${@:1:$#-1}
  virtualenv -p python2 $params $HOME/envs/$name
  cp "$HOME/envs/default/pip.conf" "$HOME/envs/$name/pip.conf"
  xx $HOME/envs/$name/bin/*
  xx $HOME/envs/$name/*
  venv "$name"
}

venv3() {
  local name="${@: -1}"
  local params=$@
  [ -z $1 ] && echo "please provide virtual env name" && read name
  [ -z $name ] && name=$(basename "$PWD")
  params=${@:1:$#-1}
  virtualenv $params $HOME/envs/$name
  cp "$HOME/envs/default/pip.conf" "$HOME/envs/$name/pip.conf"
  xx $HOME/envs/$name/bin/*
  xx $HOME/envs/$name/*
  venv "$name"
}
