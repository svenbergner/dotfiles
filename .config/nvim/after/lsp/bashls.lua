-- Language Server Protocol configuration for Bash
-- URL: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#bashls

return {
   cmd = { 'bash-language-server', 'start' },
   filetypes = { 'sh', 'bash', 'zsh' },
   root_markers = { '.git' },
   init_options = { provideFormatter = true },
   settings = {
      bashIde = {
         globPattern = '*@(.sh|.inc|.bash|.command)',
      },
   },
}
