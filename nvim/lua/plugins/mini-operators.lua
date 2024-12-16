--[=====[
Text edit operators
https://github.com/echasnovski/mini.operators

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
--]=====]

return {
  'echasnovski/mini.operators',
  enabled = false,
  version = '*',
  config = function()
    require('mini.operators').setup()
  end,
}
