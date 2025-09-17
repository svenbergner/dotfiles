--[===[
Text edit operators
URL: https://github.com/nvim-mini/mini.operators

Features:
 - Operators:
   - Evaluate text and replace with output.
   - Exchange text regions.
   - Multiply (duplicate) text.
   - Replace text with register.
   - Sort text.

- Automated configurable mappings to operate on textobject, line, selection.
  Can be disabled in favor of more control with MiniOperators.make_mappings().

- All operators support [count] and dot-repeat.

See *MiniOperators-overview* and *MiniOperators.config* tags in help for more details.
--]===]

return {
   'nvim-mini/mini.operators',
   enabled = true,
   version = '*',
   config = function()
      require('mini.operators').setup(
         {
            -- Each entry configures one operator.
            -- `prefix` defines keys mapped during `setup()`: in Normal mode
            -- to operate on textobject and line, in Visual - on selection.

            -- Evaluate text and replace with output
            evaluate = {
               prefix = 'g=',

               -- Function which does the evaluation
               func = nil,
            },

            -- Exchange text regions
            exchange = {
               prefix = 'gX',

               -- Whether to reindent new text to match previous indent
               reindent_linewise = true,
            },

            -- Multiply (duplicate) text
            multiply = {
               prefix = 'gM',

               -- Function which can modify text before multiplying
               func = nil,
            },

            -- Replace text with register
            replace = {
               prefix = 'gR',

               -- Whether to reindent new text to match previous indent
               reindent_linewise = true,
            },

            -- Sort text
            sort = {
               prefix = 'gS',

               -- Function which does the sort
               func = nil,
            }
         })
   end,
}
