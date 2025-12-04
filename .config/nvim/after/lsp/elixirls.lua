return {
   "elixir-lsp/elixir-ls",
   ft = { "elixir", "eelixir" },
   config = function()
      require("lspconfig").elixirls.setup({
         cmd = { vim.fn.expand("$HOME") .. "/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
         settings = {
         elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
         },
         },
      })
   end,
}
