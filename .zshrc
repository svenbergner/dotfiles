# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
if [[ "$OSTYPE" =~ "darwin".* ]] then
   export PATH="/usr/local/sbin:$PATH:/Users/svenbergner/Development/flutter/bin"
else
   export PATH=/home/bergner/Repos/flutter/bin/:$PATH
fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="crunch"
#ZSH_THEME="fino-time"
#ZSH_THEME="codeknight"
#ZSH_THEME="spaceship"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time stamp shown in the history command output.
# You can set one of the optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications, see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyy"

# Better Search for Commands
zstyle ':autocomplete:*' default-context history-incremental-search-backward

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(git git-prompt)
plugins+=(common-aliases sudo)
plugins+=(history history-substring-search)
plugins+=(zsh-vi-mode zsh-fzf-history-search)
plugins+=(zsh-autosuggestions zsh-syntax-highlighting)

if [[ "$OSTYPE" == "darwin".* ]] then
   plugins+=(brew)
fi

source $ZSH/oh-my-zsh.sh

# Preferred editor
export EDITOR='nvim'

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=de_DE.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'
alias v="nvim"

if [[ "$OSTYPE" == "win32" ]] then
    alias dotfiles='cd C:\\Repos\\dotfiles'
else
    alias dotfiles='cd ~/Repos/dotfiles'
    alias vimwiki='nvim ~/Repos/vimwiki/index.md'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias open="xdg-open"

# gulc -- git undo last commit but preserve the changes
alias gulc="git reset --soft HEAD~"

alias ls='exa'
alias la='ls -laa'

alias bat='bat --theme gruvbox-dark'

alias fman='compgen -c | fzf | xargs man'

if [ -e /home/bergner/.nix-profile/etc/profile.d/nix.sh ]; then 
    . /home/bergner/.nix-profile/etc/profile.d/nix.sh; 
fi # added by Nix installer

alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config " --height=20% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line
# bindkey -M vicmd v edit-command-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
