--[===[
Mkdnflow 

Description:

Mkdnflow is designed for the fluent navigation of documents and
notebooks (AKA "wikis") written in markdown. The plugin's flexibility and its
prioritization of markdown also means it can become part of your webdev
workflow if you use static site generators like Jekyll or Hugo, which can
generate static sites from markdown documents.

The plugin is an extended set of functions and mappings to those functions
which make it easy to navigate and manipulate markdown documents and notebooks
in Neovim. I originally started writing Mkdnflow to replicate some features
from Vimwiki in Lua instead of Vimscript, but my current goal for this project
is to make this plugin as useful as possible for anyone using Neovim who
maintains a set of markdown notes and wishes to efficiently navigate those
notes and keep them organized and connected. The plugin now includes some
convenience features I wished Vimwiki had, including functionality to rename
the source part of a link and its associated file simultaneously.

I keep tabs on the project's issues and appreciate feature requests,
suggestions, and bug reports. I invite you to use the discussion board if you
would like to share your config, share how Mkdnflow fits into your workflow,
get help with setup, or contribute feature suggestions or optimizations.
Contributions to the plugin are welcome: fork this repo and submit a pull
request with your changes or additions. For Lua resources, see this page or
call :h lua or :h api in Neovim.

URL: https://github.com/jakewvincent/mkdnflow.nvim
--]===]

return {
   'jakewvincent/mkdnflow.nvim',
   enabled = false,
   config = function()
      require('mkdnflow').setup({
         -- Config goes here; leave blank for defaults
      })
   end
}
