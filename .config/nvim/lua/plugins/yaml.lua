--[===[
Simple tools to help developers working YAML in Neovim
https://github.com/cuducos/yaml.nvim

Command                    Lua API                      Description
:YAMLView                  yaml.view()                  Shows the full path and value of the current key/value pair
:YAMLYank [register]       yaml.yank_all([register])    Yanks the full path and value of the current key/value pair.
                                                        The default register is the unnamed one (")
:YAMLYankKey [register]    yaml.yank_key([register])    Yanks the full path of the key for the current key/value pair.
                                                        The default register is the unnamed one (")
:YAMLYankValue [register]  yaml.yank_value([register])  Yanks the value of the current key/value pair.
                                                        The default register is the unnamed one (")
:YAMLHighlight <key>	      yaml.highlight(key)          Highlights the line(s) of an YAML key
:YAMLRemoveHighlight	      yaml.remove_highlight()      Removes the highlight created by :YAMLHighlight/yaml.highlight(key)
:YAMLQuickfix	            yaml.quickfix()              Generates a quickfix with key/value pairs
:YAMLSnacks	               yaml.snacks()                Full path key/value fuzzy finder via Snacks if installed
:YAMLTelescope	            yaml.telescope()             Full path key/value fuzzy finder via Telescope if installed
:YAMLFzfLua	               yaml.fzf_lua()               Full path key/value fuzzy finder via fzf-lua if installed
:YAMLSort	               yaml.sort()                  Sorts YAML keys alphabetically within the mapping under the cursor,
                                                        recursing into nested mappings
--]===]

return {
   'cuducos/yaml.nvim',
   enabled = true,
   ft = { 'yaml' },
   dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
   },
   config = function()
      require('yaml_nvim').setup({
         on_attach = function(client, _)
            client.resolved_capabilities.document_formatting = false
            require('nvim-treesitter.configs').setup({
               ensure_installed = 'yaml',
               highlight = { enable = true },
               indent = { enable = true },
            })
            require('telescope').load_extension('yaml')
         end,
      })

      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>yt', ':YAMLTelescope<CR>', { noremap = false })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>yl', ':!yamllint %<CR>', { noremap = true, silent = true })
   end,
}
