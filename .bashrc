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

# GUM

styled_message() {
  local border_foreground="${2:-212}"  # Use 212 if no argument is provided
  gum style --border double --margin "1" --padding "1" --bold --border-foreground $border_foreground --align center "$1"
}

# UTIL

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

gcom() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    styled_message "This is not a Git repository. Operation canceled." 9
    return 1
  fi

  # Get the list of uncommitted (modified or untracked) files
  FILES=$(git status --short | awk '{print $2}')

  if [ -z "$FILES" ]; then
    styled_message "No uncommitted files found. Operation canceled." 9
    return 1
  else
    styled_message "Select uncommitted files to stage for commit"
  fi

  # Add an option to select all files
  FILE_CHOICES=$(echo -e "All\n$FILES")
  # Prompt user to select one or more files from the list of uncommitted files
  SELECTED_FILES=$(echo "$FILE_CHOICES" | gum choose --no-limit)
  
  if echo "$SELECTED_FILES" | grep -q ""; then
    if gum confirm "Commit all changes? Press no to exit."; then
      git add .
      styled_message "All uncommitted files staged for commit" 40
    else
      styled_message "Operation cancelled" 9
      return 1
    fi
  else 
    # Stage selected files
    for FILE in $SELECTED_FILES; do
      git add "$FILE"
    done
    styled_message "Selected files staged for commit" 40
  fi

  styled_message "Choose the type of commit:"
  TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
  SCOPE=$(gum input --placeholder "Enter the scope (optional)")

  # Since the scope is optional, wrap it in parentheses if it has a value
  test -n "$SCOPE" && SCOPE="($SCOPE)"
  
  SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
  DESCRIPTION=$(gum write --placeholder "Details of this change")

  # Ensure summary is not empty
  if [ -z "$SUMMARY" ]; then
    styled_message "Summary cannot be empty. Commit aborted!" 9
    return 1
  fi

  # Confirmation spinner before committing
  if gum confirm "Commit changes?"; then
    if git commit -m "$SUMMARY" -m "$DESCRIPTION"; then
      styled_message "Commit successful!" 40

      if gum confirm "Push to remote?"; then
        gum spin --spinner dot --title "Committing to remote..." git push
      fi
    else
      styled_message "Commit failed!" 9
    fi
  else
    styled_message "Commit aborted!" 9
  fi 
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

rnh() {
  history -a
  HISTORY=$(tail -n 20 ~/.bash_history | grep -v '^#' | tac)
  styled_message "Run a command again"
  $(echo "$HISTORY" | gum choose)
}

export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:/home/louie/.local/bin


eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
