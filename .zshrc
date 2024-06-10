# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

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
fi

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

# Shell integrations
source <(fzf --zsh)
source <(zoxide init --cmd cd zsh)

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

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

# If you come from bash you might have to change your $PATH.
if [[ "$OSTYPE" =~ "darwin".* ]] then
   export PATH="/usr/local/sbin:$PATH:/Users/svenbergner/Development/flutter/bin"
else
   export PATH=/home/bergner/Repos/flutter/bin/:$PATH
fi

# Better Search for Commands
zstyle ':autocomplete:*' default-context history-incremental-search-backward
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

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

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

