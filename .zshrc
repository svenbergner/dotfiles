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

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# Add in snippts
zinit snippet OMZP::git
zinit snippet OMZP::git-prompt
zinit snippet OMZP::common-aliases
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::history

if [[ "$OSTYPE" == "darwin".* ]] then
#    plugins+=(brew)
  zinit snippet OMZP::brew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/codeknight.toml)"
fi

# Keybindings
bindkey -e

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

# If you come from bash you might have to change your $PATH.
if [[ "$OSTYPE" =~ "darwin".* ]] then
   export PATH="/usr/local/sbin:$PATH:/Users/sven.bergner/fvm/default/bin"
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Preferred editor
export EDITOR='nvim'

# User configuration

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
## [/Completion]

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

