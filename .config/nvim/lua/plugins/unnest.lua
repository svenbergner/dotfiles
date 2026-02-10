--[===[
unnest.nvim
https://github.com/brianhuster/unnest.nvim

Unnest your nested Neovim sessions.

Introduction
Imagine that you are in a terminal buffer in Nvim, and you run a command that
opens a new Nvim instance (e.g., git commit). Now you have a Neovim session
running inside another Neovim session. This can be confusing and inefficient.

Solves this by detecting when it's being run in a nested session, then it will
instruct the parent Neovim instance to open files in a in the parent Neovim instance.
--]===]

return {
   'brianhuster/unnest.nvim',
   enabled = true,
}
