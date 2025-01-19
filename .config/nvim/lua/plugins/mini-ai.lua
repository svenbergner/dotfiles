--[===[
MiniAI plugin
URL: https://www.github.com/echasnovski/mini.ai
Extend and create a/i textobjects
Features:
- Customizable creation of a/i textobjects using Lua patterns and functions. Supports:
  - Dot-repeat.
  - v:count.
  - Different search methods (see help for MiniAi.config).
  - Consecutive application (update selection without leaving Visual mode).
  - Aliases for multiple textobjects.
- Comprehensive builtin textobjects (see more in help for MiniAi-textobject-builtin):
  - Balanced brackets (with and without whitespace) plus alias.
  - Balanced quotes plus alias.
  - Function call.
  - Argument.
  - Tag.
  - Derived from user prompt.
  - Default for punctuation, digit, or whitespace single character.
- Motions for jumping to left/right edge of textobject.
- Set of specification generators to tweak some builtin textobjects (see help for MiniAi.gen_spec).
- Treesitter textobjects (through MiniAi.gen_spec.treesitter() helper).
--]===]

return {
   'echasnovski/mini.ai',
   enabled = true,
   version = '*',
   config = function()
      require('mini.ai').setup()
   end,
}
