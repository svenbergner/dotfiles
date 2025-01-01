# dotfiles
My config files

## Active used configs

### Neovim lua config
After using several IDEs and Vim I ended up using Neovim as my PDE (Personal Development Environment.)
[NeoVim Readme](/.config/nvim/README.md)

### lazygit
My preferred way to deal with my git repos. I even have a neovim plugin to have it all the time right at my
fingertips.
Lazygit is integrated into my neovim config using snacks.nvim and I use it as a git client.
[lazygit config](./lazygit)

### wezterm
After using a bunch of terminal emulators and multiplexers I'm currently using wezterm.
Following points were my reason to switch:
 - configuration is written in lua. Same as neovim.
 - highly customizable using lua
 - no need to use a multiplexer
 - supports kitty image protocol
 - fast and lightweight

### eza
A modern replacement for the ls command. It is written in rust and has a lot of features.
I use it as my default ls command. 

### zoxide
A smarter cd command with memory. It is written in rust and I use it as a in-place replacement cd command.

### delta
A viewer for git and diff output. I use it as my default git diff viewer.

### bat
A cat clone with syntax highlighting and git integration. I use it as my default cat command.

### stow
I use stow to manage my dotfiles. It is a symlink farm manager. I reorganized my dotfiles to use stow.

## Colors

My preferred colorscheme is **gruvbox dark**. Therefore I have the colors as iTerm colors and in a simply json format.
I use these colors in my wezterm statusbar, lazygit, bat, delta and neovim.

## Scripts

### cht.sh

This script can be used to look up information from the cht.sh website.

## Fallback config

### vimrc
I stripped down my .vimrc to a minimal one-file configuration without any external
dependencies. No package manager is used. So it can easily be copied to any
machine and I have a really good base to work with within seconds.

