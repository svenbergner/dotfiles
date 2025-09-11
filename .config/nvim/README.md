# My Neovim Config

*IMPORTANT:* This is my personal neovim config and is in no way intended to be
used by someone else without knowing what it does. 
It is a collection of plugins and settings that I like to use. Take it as an
inspiration or a starting point for your own config.
**Use at your own risk!**

The config is written in lua. External packages are getting installed and updated
using the lazy.nvim package manager.

# Recommended Youtube Videos

## Kickstarter
- [The Only Video You Need to Get Started with Neovim](https://www.youtube.com/watch?v=m8C0Cq9Uv9o)

## The starting point: init.lua

It's the main entry point of the config. It sets up the package manager and
requires the other lua files (autocmds, globals, keymaps and options) in the 
config folder.

## File type detection

In the subfolder `ftdetect` there are some files to detect the file type of some
files that are not detected by default.

- Treat files ending with aavdrm as dosini files to get proper syntax highlighting.
- Set explicitly *.pri and *.pro files to qmake syntax.
- Set explicitly *.yaml and *.yml files to filetype yaml.

## lua

### Plugins Folder

Each plugin has a header comment with a link to the github repo and a short 
description of what it does and how to use it.
To open a link just put the cursor over the link and press `gx` to open it in 
your system browser.
 
## Spellchecking

The folder spell contains spell checking files for the German language.

## Syntax Highlighting

The folder syntax contains a vimscript file which adds syntax highlighting for
Qt qmake files.
