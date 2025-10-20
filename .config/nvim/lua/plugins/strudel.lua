--[===[
strudel.nvim
A Neovim plugin that integrates with Strudel, a live coding web editor for algorithmic music and visuals.

This plugin launches Strudel in a browser window and provides real-time two-way synchronization between a selected Neovim buffer and the Strudel editor, as well as remote Strudel controls (play/stop, update), and much more!

URL: https://github.com/gruvw/strudel.nvim
--]===]

return {
   "gruvw/strudel.nvim",
   build = "npm install",
   config = function()
      require("strudel").setup()
      local strudel = require("strudel")

      vim.keymap.set("n", "<leader>Sl", strudel.launch, { desc = "Launch Strudel" })
      vim.keymap.set("n", "<leader>Sq", strudel.quit, { desc = "Quit Strudel" })
      vim.keymap.set("n", "<leader>St", strudel.toggle, { desc = "Strudel Toggle Play/Stop" })
      vim.keymap.set("n", "<leader>Su", strudel.update, { desc = "Strudel Update" })
      vim.keymap.set("n", "<leader>Ss", strudel.stop, { desc = "Strudel Stop Playback" })
      vim.keymap.set("n", "<leader>Sb", strudel.set_buffer, { desc = "Strudel set current buffer" })
      vim.keymap.set("n", "<leader>Sx", strudel.execute, { desc = "Strudel set current buffer and update" })
   end,
}
