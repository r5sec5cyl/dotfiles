#!/bin/bash
# public
# Docker cleanup
alias clearcont='docker rm $(docker ps -a -q)'
alias clearimages='docker rmi $(docker images -a -q)'
alias cld='clearcont;clearimages;docker system prune'

# Docker build / run
alias dc='docker-compose'
alias d='docker'

# Docker other
alias dinfo='docker history'
alias dhist='docker history --no-trunc'

dbash() { ## bash shell into a container
  export choice_set=`echo "$(docker ps)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "Entering container $c_id" && docker exec -it $c_id bash
}

dsh() { ## sh shell into a container
  export choice_set=`echo "$(docker ps)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "Entering container $c_id" && docker exec -it $c_id sh
}

dlogs() { ## check docker logs
  export choice_set=`echo "$(docker ps -a)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "Logs for container $c_id:" && docker logs $c_id
}

dkill() { ## kill docker container
  export choice_set=`echo "$(docker ps)\n" | awk '!/CONTAINER ID/' | grep ".*$1.*"`
  get_choice
  p="p"
  [ "$choice_set" != "" ] && local c_id=$(printf $choice_set | awk '{print $1}') && docker kill $c_id
}
