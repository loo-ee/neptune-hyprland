# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit ice depth=1; zinit light romkatv/powerlevel10k

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias journal='journalctl -p 3 -xb'

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
    "zsh")
      nvim /home/louie/.zshrc
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

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
