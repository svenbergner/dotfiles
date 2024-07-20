-- Shows the available keymaps
return {
   'folke/which-key.nvim',
   event = 'VeryLazy',
   dependencies = {
      { 'echasnovski/mini.icons', version = false },
   },
   config = function()
      require('which-key').setup({
         win = {
            no_overlap = true,
            border = "single",
            margin = { 2, 20, 2, 20 },
            padding = { 2, 5, 2, 5 },
            winblend = 20,
         },
         layout = {
            align = "center",
         },
         -- document existing key chains
         keys = {
            { "<leader>c",  group = "[C]ode" },
            { "<leader>c_", hidden = true },
            { "<leader>d",  group = "[D]ocument" },
            { "<leader>d_", hidden = true },
            { "<leader>g",  group = "[G]it" },
            { "<leader>g_", hidden = true },
            { "<leader>h",  group = "Git [H]unk" },
            { "<leader>h_", hidden = true },
            { "<leader>r",  group = "[R]ename" },
            { "<leader>r_", hidden = true },
            { "<leader>s",  group = "[S]earch" },
            { "<leader>s_", hidden = true },
            { "<leader>t",  group = "[T]oggle" },
            { "<leader>t_", hidden = true },
            { "<leader>w",  group = "[W]orkspace" },
            { "<leader>w_", hidden = true },
         }
      })
   end
}
