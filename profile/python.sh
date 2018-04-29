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
  name="${@: -1}"
  params=""
  [ -z $1 ] && echo "please provide virtual env name" && read name
  for i in "$@"
  do
    if [ "$i" != "$name" ]; then
      params="$params $i"
    fi
  done
  virtualenv$params "$HOME/envs/$name"
  cp "~/envs/default/pip.conf" "~/envs/$name/pip.conf"
  xx ~/envs/$name/bin/*
  xx ~/envs/$name/*
  venv "$name"
}
