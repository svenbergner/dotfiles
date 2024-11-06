# dotfiles
My config files

## Active used configs

### Neovim lua config
After using several IDEs and Vim I ended up using Neovim as my PDE (Personal Development Environment.)
[NeoVim Readme](/.config/nvim/README.md)

### lazygit
My preferred way to deal with my git repos. I even have a neovim plugin to have it all the time right at my
fingertips.
[lazygit config](./lazygit)

### wezterm
After using a bunch of terminal emulators and multiplexers I'm currently using wezterm.
Following points were my reason to switch:
 - configuration is written in lua. Same as neovim.
 - highly customizable using lua
 - no need to use a multiplexer
 - supports kitty image protocol
 - fast and lightweight

## Colors

My preferred colorscheme is **gruvbox dark**. Therefore I have the colors as iTerm colors and in a simply json format.
I use these colors in my wezterm statusbar, lazygit, delta and neovim.

## Scripts

### cht.sh

This script can be used to look up information from the cht.sh website.

## Fallback config

### vimrc
I stripped down my .vimrc to a minimal one-file configuration without any external
dependencies. No package manager is used. So it can easily be copied to any
machine and I have a really good base to work with within seconds.


## Older configs

Tools I used for some time on my way to a perfect development setup.

### zellij
A terminal multiplexer with a nice and easy TUI. It has a very low learning curve but after some time I wanted to get
my screen space back to use it for my work and not for help text.

### tmux


