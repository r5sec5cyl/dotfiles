# k8s.sh
alias kc=kubectl
alias ka=kubeadm
alias kfc=kubefedctl
alias mk=minikube
alias k=kc
alias kf=kfc
alias kb=kubebuilder
alias kz=kustomize

kt() {
  export choice_set=`echo "$(k get pods)" | awk '!/RESTARTS/' | grep ".*$1.*"`
  get_choice $1
  p="p"
  [ "$choice_set" != "" ] && local pod_id="`printf \"$choice_set\" | cut -d" " -f1 | sed -n $s$p 2>/dev/null`" && echo "tailing $pod_id" && k logs $pod_id --follow ${@:2:$#}
}
