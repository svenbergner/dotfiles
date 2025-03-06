--[===[
Telescope - the swiss army knife for finding things
URL: https://github.com/nvim-telescope/telescope.nvim
--]===]

return {
   {
      "nvim-telescope/telescope.nvim",
      enabled = true,
      dependencies = {
         "nvim-lua/plenary.nvim",
         { "svenbergner/telescope-debugee-selector",      dev = true },
         { "svenbergner/telescope-cmake-preset-selector", dev = true },
      },
      config = function()
         require("telescope").setup({
            path_display = { "truncate" },
            pickers = {
               find_files = {
                  -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                  find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
               },
            },
            defaults = {
               sorting_strategy = 'ascending',
            },
         })
         -- Personal extensions
         require("telescope").load_extension("cmake_preset_selector")
         require("telescope").load_extension("debugee_selector")
      end,
   },
}
