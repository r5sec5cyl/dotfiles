#!/bin/bash
# k8s.sh
alias ka=kubeadm
alias mk=minikube
alias k=kubectl
alias kb=kubebuilder
alias kz=kustomize

kt() { ## tail logs for pod
  export choice_set=`echo "$(k get pods)" | awk '!/RESTARTS/' | grep ".*$1.*"`
  get_choice $1
  p="p"
  [ "$choice_set" != "" ] && local pod_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "tailing $pod_id" && k logs $pod_id --follow ${@:2:$#}
}

kctx() { ## change current context for kubeconfig
  local vals=$(k config get-contexts)
  printf "$vals" | head -1
  export choice_set=$(printf "$vals" | sed "1 d" | grep ".*$1.*" )
  get_choice $@
  if [ "$choice_set" != "" ]; then
    k config use-context $(echo "$choice_set" | sed 's/\*/\ /g' | sed -e 's/^\ *//' | cut -d" " -f1)
  fi
}

kns() { ## set default namespace for current context
  local vals=$(k get namespaces)
  printf "$vals" | head -1
  export choice_set=$(printf "$vals" | sed "1 d" | grep ".*$1.*" )
  get_choice $@
  if [ "$choice_set" != "" ]; then
    default_ns=$(echo "$choice_set" | sed 's/\*/\ /g' | sed -e 's/^\ *//' | cut -d" " -f1)
    if [ "$default_ns" == "default" ]; then default_ns=""; fi;
    k config set-context --namespace=$default_ns --current
  fi
}
