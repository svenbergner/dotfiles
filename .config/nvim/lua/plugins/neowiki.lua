--[===[
neowiki.nvim
https://github.com/echaya/neowiki.nvim

Modern Vimwiki Successor for Instant Notes & GTD 🚀📝

🌟 Introduction
neowiki.nvim is a lightweight, first-class Neovim citizen with Lua finesse,
offering a minimal, intuitive workflow out of the box for note-taking and
Getting Things Done (GTD).

🔥 Key Features
Flexible Wiki Access 🪟
Open wikis your way—in the current buffer, a new tab, or a distraction-free
floating window for focused note-taking.

Effortless Linking & Navigation 🔗
Create and follow markdown links with <CR>, split with <S-CR> or <C-CR>, and
jump between links using <Tab>/<S-Tab>. Navigate page history like a browser
with [[ and ]], or return to index.md with <BS>.

Smart Task Management ✅
Toggle tasks with <leader>wt ([ ] ↔ [x]) and track nested task progress in
real-time with dynamic updates.

Robust Wiki Organization 📂
Manage multiple wikis (e.g., work, personal) with automatic discovery of
nested index.md files. Easily insert, rename, or delete wiki pages with
automatic backlink updates.

Neovim-Powered Efficiency ⚙️
Built for Neovim 0.10+, leveraging Lua for speed and seamless integration with
other plugins: Treesitter, markdown rendering, completion, pickers, and your
existing config.
--]===]

return {
   'echaya/neowiki.nvim',
   enabled = true,
   event = 'VeryLazy',
   opts = {
      wiki_dirs = {
         {
            name = 'Personal',
            path = '~/Repos/vimwiki/',
         },
         {
            name = 'Work',
            path = '~/Repos/workwiki/',
         },
      },
   },
   keys = {
      { '<leader>WW', '<cmd>lua require(\'neowiki\').open_wiki_floating()<cr>', desc = 'Open Wiki in Floating Window' },
   },
}
