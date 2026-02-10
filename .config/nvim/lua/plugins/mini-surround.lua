--[===[
Fast and feature-rich surround actions
https://github.com/nvim-mini/mini.surround

- Actions (all of them are dot-repeatable out of the box and respect v:count
  for searching surrounding) with configurable keymappings:
  - Add surrounding with sa (in visual mode or on motion).
  - Delete surrounding with sd.
  - Replace surrounding with sr.
  - Find surrounding with sf or sF (move cursor right or left).
  - Highlight surrounding with sh.
  - Change number of neighbor lines with sn (see |MiniSurround-algorithm|).

- Surrounding is identified by a single character as both "input"
  (in delete and replace start, find, and highlight) and "output"
  (in add and replace end):
  - 'f' - function call (string of alphanumeric symbols or '_' or '.'
    followed by balanced '()'). In "input" finds function call, in "output"
    prompts user to enter function name.
  - 't' - tag. In "input" finds tag with same identifier, in "output" prompts
    user to enter tag name.

  - All symbols in brackets '()', '[]', '{}', '<>". In "input' represents
    balanced brackets (open - with whitespace pad, close - without),
    in "output" - left and right parts of brackets.

  - '?' - interactive. Prompts user to enter left and right parts.

  - All other alphanumeric, punctuation, or space characters represent
    surrounding with identical left and right parts.

- Configurable search methods to find not only covering but possibly next,
  previous, or nearest surrounding. See more in help for MiniSurround.config.

- All actions involving finding surrounding (delete, replace, find, highlight)
  can be used with suffix that changes search method to find previous/last.
  See more in help for MiniSurround.config.
--]===]

return {
   'nvim-mini/mini.surround',
   enabled = true,
   version = '*',
   config = function()
      require('mini.surround').setup()
   end,
}
