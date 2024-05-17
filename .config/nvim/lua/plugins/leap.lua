-- Leap is a general-purpose motion plugin for Neovim, building and improving
-- primarily on vim-sneak, with the ultimate goal of establishing a new standard
-- interface for moving around in the visible area in Vim-like modal editors.
-- It allows you to reach any target in a very fast, uniform way, and minimizes
-- the required focus level while executing a jump.
--
-- Usage:
-- Jumping forward
-- Initiate the search using s
-- Start typing a 2-character pattern ({char1}{char2}) that you want to jump to.
-- After typing the first character, you will see labels appearing next to some 
-- of the {char1}{?} pairs. You cannot use the labels yet 
-- (make sure to always finish typing two characters).
-- Enter `{char2}`. If the pair was not labeled, then you will jump there automatically. 
-- If there are multiple matches, type the label character and you will jump there.
-- You can hit v to enter visual select mode and then s to start leap to visually select text.
--
-- Jumping backward
-- Follow the same steps above but use S instead of s.
-- WARN: Not working at the moment
--
-- NOTE: visual selection not working backwards by hitting v and then using S. 
-- I am unsure if this is my config or a limitation of the plugin.
--
-- Jumping across windows (aka splits)
-- use gs instead of s.
--
-- Jumping to end of lines
-- Since there is no set of characters to match when jumping to the end of a line, you need a special combination.
--
-- A character at the end of a line or with a space following it can be targeted by pressing <space> after it.
--
-- Hit s and then <char><space> OR s, then <space><space> to jump to the end of a line.
--
-- Searching
-- If you have already jumped but want to jump to the next match, s<enter> uses the previous search pattern.
--
-- NOTE: Additional Features and FAQ
-- https://github.com/ggandor/leap.nvim?tab=readme-ov-file#faq


return {
   "ggandor/leap.nvim",
   dependencies = {
      "tpope/vim-repeat",
   },
   lazy = false,
   config = function()
      local leap = require('leap')
      leap.add_default_mappings()
      leap.opts.case_sensitive = true
      vim.api.nvim_create_autocmd('ColorScheme', {
         callback = function()
            require('leap').init_highlight(true)
         end,
         pattern = '*',
      })
   end
}
