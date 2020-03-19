# public
# Docker cleanup
alias clearcont='docker rm $(docker ps -a -q)'
alias clearimages='docker rmi $(docker images -a -q)'
alias cld='clearcont;clearimages;docker system prune'

# Docker build / run
alias dc='docker-compose'
alias d='docker'
alias dcbuild='docker-compose build --no-cache'
alias dcup='docker-compose up'
alias buildup='dcbuild;dcup'
alias dcrun='docker-compose run --rm'
alias burn='buildup;dcrun'
alias drun='docker run -it'
alias drunproxy='docker run -e http_proxy=$"$http_proxy" -it'
alias dbuild='docker build --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$http_proxy --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg proxy=$http_proxy'

# Docker other
alias dinfo='docker history'
alias dhist='docker history --no-trunc'

dbash() {
  export choice_set=`echo "$(docker ps)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "Entering container $c_id" && docker exec -it $c_id bash
}

dsh() {
  export choice_set=`echo "$(docker ps)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "Entering container $c_id" && docker exec -it $c_id sh
}

dlogs() {
  export choice_set=`echo "$(docker ps -a)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "Logs for container $c_id:" && docker logs $c_id
}

dkill() {
  export choice_set=`echo "$(docker ps)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && docker kill $c_id
}
