if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
# If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
#zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
#buggy with reported bug regarding control+w
#zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward
bindkey '^[w' kill-region
#fix to navigate with ctrl + left and ctrol + right
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
  
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
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# This will be our new default `alt+backspace` command
my-backward-delete-word() {
    # Copy the global WORDCHARS variable to a local variable. That way any
    # modifications are scoped to this function only
    local WORDCHARS=$WORDCHARS
    # Use bash string manipulation to remove `:` so our delete will stop at it
    WORDCHARS="${WORDCHARS//:}"
    # Use bash string manipulation to remove `/` so our delete will stop at it
    WORDCHARS="${WORDCHARS//\/}"
    # Use bash string manipulation to remove `.` so our delete will stop at it
    WORDCHARS="${WORDCHARS//.}"
    # zle <widget-name> will run an existing widget.
    zle backward-kill-word
}
# `zle -N` will create a new widget that we can use on the command line
zle -N my-backward-delete-word
# bind this new widget to `ctrl+w`
bindkey '^[^?' my-backward-delete-word

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# Shell integrations
eval "$(fzf --zsh)"

# Configuration for virtualenv
export WORKON_HOME=$HOME/.virtualenvs
#export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/opt/homebrew/bin/virtualenv
source /opt/homebrew/bin/virtualenvwrapper.sh

