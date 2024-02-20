-- Shows a preview of the code action before applying it
return {
   "aznhe21/actions-preview.nvim",
   config = function()
      vim.keymap.set({ "v", "n" }, "ca", require("actions-preview").code_actions, { desc = "Preview [ C ]ode [ A ]ctions" })
   end
}
