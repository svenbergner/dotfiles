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

## Remote document opening

The `remote_open` Lua module allows an external program to select a running
Neovim instance by project directory and open a document at a source position.
It is loaded from `init.lua` and activates only when `WEZTERM_PANE` is present.
Other Neovim sessions keep their normal startup behavior.

During startup the module records the normalized initial working directory,
WezTerm pane ID, WezTerm GUI socket, and a focus timestamp. It starts a unique
Neovim RPC Unix socket below `stdpath('cache')/remote-open`. `FocusGained`
updates the timestamp, while `VimLeavePre` stops the server and removes its
socket.

The module exposes two functions to trusted local RPC clients:

- `info()` returns the project root, pane ID, WezTerm socket, focus timestamp,
  and protocol version used for instance selection.
- `open(payload)` decodes a Base64-encoded JSON payload, validates the existing
  file and positive position, uses `:drop` to reuse an existing buffer where
  possible, and moves the cursor.

The cache directory is created with user-only permissions. Encoding the payload
and using Neovim's structured command API avoids constructing Ex commands from
the document path.

The companion `~/scripts/nvim-open` command discovers these sockets, ignores and
removes unreachable entries, chooses the longest matching project root, and
focuses the registered pane after a successful RPC call. User-facing setup,
examples, Qt integration, and troubleshooting are documented in the
[main README](../../README.md#nvim-open).
