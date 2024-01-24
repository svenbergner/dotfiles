return {
   "vimwiki/vimwiki",
   dependencies = {
      'mattn/calendar-vim',
   },
   init = function()
      vim.g.vimwiki_ext2syntax = { ['.md'] = 'markdown', ['.markdown'] = 'markdown', ['.mdown'] = 'markdown' }
      vim.g.vimwiki_list = {
         {
            auto_diary_index = 1
         },
         {
            path = '~/Repos/vimwiki',
            syntax = 'markdown',
            ext = 'md'
         },
         {
            path = '~/Repos/buch',
            syntax = 'markdown',
            ext = 'md'
         },
      }

      vim.g.vimwiki_diary_months = {
         ["1"] = "Januar",
         ["2"] = "Februar",
         ["3"] = "März",
         ["4"] = "April",
         ["5"] = "Mai",
         ["6"] = "Juni",
         ["7"] = "Juli",
         ["8"] = "August",
         ["9"] = "September",
         ["10"] = "Oktober",
         ["11"] = "November",
         ["12"] = "Dezember",
      }

      local api = vim.api
      api.nvim_create_user_command('Diary', 'VimwikiDiaryIndex', {})

      local vimwikigroup = api.nvim_create_augroup('vimwikigroup', { clear = true })

      api.nvim_create_autocmd("FileType", {
         group = vimwikigroup,
         pattern = "vimwiki",
         command = 'setlocal shiftwidth=6 tabstop=6 noexpandtab'
      })

      -- automatically update links on read diary
      api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
         group = vimwikigroup,
         pattern = "diary.wiki",
         command = "VimwikiDiaryGenerateLinks",
      })

      -- insert diary entry header
      api.nvim_create_autocmd("BufNewFile", {
         group = vimwikigroup,
         pattern = "*/diary/[0-9]*.(wiki|md)",
         command =
         'call append(0,[ "# " . strftime("%d.%m.%Y"), "", "## Tagebuch", "", "", "## Erkenntnis des Tages", "" ])',
      })

      vim.keymap.set("n", "<F3>", 'i<C-R> =strftime("%A, %d.%m.%Y %I:%M")<CR><ESC>',
         { desc = "Insert current date and time" })
      vim.keymap.set("i", "<F3>", '<C-R> =strftime("%d.%m.%Y %I:%M")<CR>', { desc = "Insert current date and time" })
   end
}
