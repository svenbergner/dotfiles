# zinit zsh plugin manager
# zinit home folder
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# zinit clone repo if not already available
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

autoload -U compinit && compinit

# Add in zsh plugins
zinit wait lucid light-mode for \
  atinit'zicompinit; zicdreplay' \
    zdharma-continuum/fast-syntax-highlighting \
  zsh-users/zsh-completions \
  atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  zsh-users/zsh-history-substring-search \
  Aloxaf/fzf-tab

# Add in snippts
zinit wait lucid light-mode for \
  OMZP::git \
  OMZP::git-prompt \
  OMZP::sudo \
  OMZP::archlinux \
  OMZP::command-not-found \
  OMZP::history

zinit snippet OMZP::common-aliases

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search
ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES=1

# Show vi mode in prompt
# https://github.com/jeffreytse/zsh-vi-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

if [[ "$OSTYPE" == "darwin".* ]] then
#    plugins+=(brew)
  zinit snippet OMZP::brew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(starship init zsh)"

# Keybindings -e for emacs, -v for vi
bindkey -e

# History
HISTSIZE=100000
HISTFILE=~/.zsh_history
HISTCONTROL=ignoreboth
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt append_history share_history inc_append_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Additional options
setopt auto_menu menu_complete
setopt autocd

# If you come from bash you might have to change your $PATH.
if [[ "$OSTYPE" =~ "darwin".* ]] then
   export PATH="/usr/local/sbin:$PATH:/Users/sven.bergner/fvm/default/bin"
  export CMAKE_ANDROID_NDK=/Users/sven.bergner/Library/Android/sdk/ndk/28.0.12674087
else
   export PATH=/home/bergner/Repos/flutter/bin/:$PATH
fi

# Shell integrations
source <(fzf --zsh)
source <(zoxide init --cmd cd zsh)
source <(gitleaks completion zsh)

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export BAT_THEME="gruvbox-dark"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.zsh) for the details
_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh
# Unbind ^G which is used by fzf
bindkey -r '^G'

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --style=header,grid --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always --icons=always {} | head -200' "$@" ;;
    export|unset) fzf --preview 'eval 'echo \$' {}' "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
  esac
}

# Better Search for Commands
zstyle ':autocomplete:*' default-context history-incremental-search-backward
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' rehash true
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Preferred editor
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'

# User configuration

# Activate vim mode
bindkey -v

# Function to change cursor shape
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'  # Set cursor to block
  else
    echo -ne '\e[5 q'  # Set cursor to beam
  fi
}

# Function to reset cursor shape on exit
function zle-line-init {
  echo -ne '\e[5 q'  # Set cursor to beam
}

# Bind the functions to zle events
zle -N zle-keymap-select
zle -N zle-line-init

# Ensure the cursor shape is set correctly when starting zsh
zle-keymap-select

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=de_DE.UTF-8

if [[ -f ~/.zsh.aliases ]] then
  source ~/.zsh.aliases
fi

if [[ -f ~/.zsh.functions ]] then
  source ~/.zsh.functions
fi

if [[ -f ~/.zsh.local ]] then
  source ~/.zsh.local
fi

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line


## [Completion]
## Completion scripts setup. Remove the following line to uninstall
if [[ -f /Users/sven.bergner/.dart-cli-completion/zsh-config.zsh ]] then 
  source /Users/sven.bergner/.dart-cli-completion/zsh-config.zsh 
fi
if [[ -f /opt/homebrew/share/zsh/site-functions ]]; then
  source /opt/homebrew/share/zsh/site-functions
fi
## [/Completion]

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH:$HOME/scripts"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

eval $(starship completions zsh)
