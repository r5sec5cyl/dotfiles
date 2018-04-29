[[ "$0" =~ "dotfiles/profile" ]] && PROFILE_DIR=$(dirname $0) || PROFILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sources=( core navigation git docker python java )
for i in "${sources[@]}"
do
  source "$PROFILE_DIR/$i.sh"
done
