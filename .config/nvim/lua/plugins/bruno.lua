--[===[
bruno.nvim

Features:
- Execute Bruno requests - Run .bru files directly from Neovim
- Smart fallback - Uses last opened .bru file when current buffer isn't a Bruno file
- Environment switching - Select Bruno environments via a picker (telescope, fzf-lua, or snacks)
- Formatted output - Clean response display with request details and JSON formatting
- Output toggle - Switch between formatted and raw JSON output
- Content search - Search Bruno files by their contents using your chosen picker
- Persistent sidebar - Reuses output buffer to avoid window clutter

URL: https://github.com/romek-codes/bruno.nvim
--]===]

return {
   "romek-codes/bruno.nvim",
   dependencies = {
      "nvim-lua/plenary.nvim",
      -- Pickers
      {
         "folke/snacks.nvim",
         opts = { picker = { enabled = true } },
      },
   },
   config = function()
      require("bruno").setup(
         {
            -- Paths to your bruno collections.
            collection_paths = {
               { name = "Main", path = vim.fn.expand("$HOME") .. "/Repos/node-taxcore-api-v2/" },
            },
            -- Which picker to use, "fzf-lua" or "snacks" are also allowed.
            picker = "snacks",
            -- If output should be formatted by default.
            show_formatted_output = true,
            -- If formatting fails for whatever reason, don't show error message (will always fallback to unformatted output).
            suppress_formatting_errors = false
         }
      )
   end
}
