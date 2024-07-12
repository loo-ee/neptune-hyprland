#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# alias mux='pgrep -vx tmux > /dev/null && \
#   tmux new -d -s delete-me && \
#   tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh && \
#   tmux kill-session -t delete-me && \
#   tmux attach || tmux attach'

start_psql() {
  sudo systemctl start postgresql.service
}

start_docker() {
  sudo systemctl start docker.service

}

stop_docker() {
  sudo systemctl stop docker.service
}

check_bat() {
  upower -i $(upower -e | grep 'BAT')
}

gc1() {
  file=$1
  message=$2
  git add $file
  git commit -m "$message"
}

gcom() {
  message=$1
  git add .
  git commit -m "$message"
}

gcp() {
  message=$1
  git add .
  git commit -m "$message"
  git push
}

set_bat_limit() {
  if [[ $1 -gt 100 ]] || [[ $1 -lt 50 ]]
  then
    echo "Parameter must be within 50 to 100."
  else 
    sudo echo $1 > /home/louie/.batt_threshold
    sudo systemctl restart battery-charge-threshold.service
  fi
}

clear_clipboard() {
  cliphist wipe  
}

clear_packages_cache() {
  du -sh /var/cache/pacman/pkg/
  sudo pacman -Sc
}

edit-config() {
case $1 in
  "bash")
    nvim /home/louie/.bashrc
    ;;
  "neo")
    nvim /home/louie/.config/nvim
    ;;
  "starship")
    nvim /home/louie/.config/starship.toml
    ;;
  "git")
    nvim /home/louie/.gitconfig
    ;;
  *)
    echo "Unknown command..."
    ;;
esac
}

eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
