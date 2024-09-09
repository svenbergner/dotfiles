-- Highlight todo, notes, etc in comments
-- TODO: 
-- OPTIMIZE:
-- PERFORMANCE:
-- TEST:
-- PROJECT:
-- FIXME:
-- BUG:
-- WARN:
-- HACK:
-- NOTE:
-- INFO:

return {
   'folke/todo-comments.nvim',
   dependencies = {
      'nvim-lua/plenary.nvim'
   },
   opts = {
      signs = true,
      keywords = {
         FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
         PROJECT = { icon = "  ", color = "info", alt = { "PROJECT" } },
         TODO = { icon = " ", color = "info", alt = { "TODO" } },
         WARN = { icon = " ", color = "warning", alt = { "WARN", "WARNING" } },
         NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
   },
}
