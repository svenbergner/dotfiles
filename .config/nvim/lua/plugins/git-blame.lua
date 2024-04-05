-- Show git blame at the end of each line
return {
   "f-person/git-blame.nvim",
   event = 'VeryLazy',
   opts = {
      gitblame_date_format = '%d.%m.%y %H:%M',
      gitblame_message_template = '<author>  <date>  <summary>',
      gitblame_message_when_not_committed = 'Not Committed Yet',
      gitblame_display_virtual_text = 0,
      gitblame_ignored_filetypes = { 'log', 'dump' },
   },
}
