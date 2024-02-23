-- Highlight todo, notes, etc in comments
-- TODO: 
-- FIXME:
-- WARN:
-- NOTE:
--
return {
   'folke/todo-comments.nvim',
   dependencies = {
      'nvim-lua/plenary.nvim'
   },
   opts = { signs = true },
}
