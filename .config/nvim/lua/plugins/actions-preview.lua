--[===[
Shows a preview of the code action before applying it
URL: https://github.com/aznhe21/actions-preview.nvim
--]===]

return {
   "aznhe21/actions-preview.nvim",
   event = 'VeryLazy',
   enabled = true,
   config = function()
      vim.keymap.set({ "v", "n" }, "ca", require("actions-preview").code_actions, { desc = "Preview [c]ode [a]ctions" })
   end
}
