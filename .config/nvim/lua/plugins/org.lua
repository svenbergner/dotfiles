--[===[
Emacs Org mode, rebuilt for Neovim in pure Lua
https://github.com/xheisenbugx/org.nvim
--]===]

return {
   'xheisenbugx/org.nvim',
   enabled = true,
   main = 'org',
   lazy = false, -- startup cost is small: heavy modules load on first use
   opts = {
      org_directory = '~/org',
      agenda_files = { '~/org/**/*.org' },
      default_notes_file = '~/org/refile.org',
   },
}
