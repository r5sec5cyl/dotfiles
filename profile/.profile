# .profile
[[ "$0:A" =~ "dotfiles/profile" ]] && PROFILE_DIR=$(dirname $0:A) || PROFILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sources=( functions navigation git docker python java k8s applications )
for i in "${sources[@]}"
do
  source "$PROFILE_DIR/$i.sh"
done
