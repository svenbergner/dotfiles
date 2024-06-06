-- 💻 lazydev.nvim
-- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by lazily updating your workspace libraries.
--
-- ✨ Features
-- much faster auto-completion, since only the modules you require in open Neovim files will be loaded.
-- no longer needed to configure what plugin sources you want to have enabled for a certain project
-- load third-party addons from LLS-Addons
-- will update your workspace libraries for:
-- require statements: require("nvim-treesitter")
-- module annotations: ---@module "nvim-treesitter"
-- nvim-cmp and nvim_coq completion source for the above
-- 2024-06-01_21-02-40
--
-- ⚠️ Limitations
-- If you have files that only use types from a plugin, then those types won't be available in your workspace.
-- completion for module names when typing require(...) will only return loaded modules in your workspace.
-- To get around the above, you can:
-- pre-load those plugins with the library option.
-- use the nvim-cmp or coq_nvim completion source to get all available modules.
-- Neovim types are NOT included and also no longer needed on Neovim >= 0.10

return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
}
