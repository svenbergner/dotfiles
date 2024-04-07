-- Flutter Test support
return {
   "nvim-neotest/neotest",
   dependencies = {
      { "sidlatau/neotest-dart" },
   },
   config = function()
      require('neotest').setup({
         adapters = {
            require('neotest-dart') {
               command = "fvm flutter",
               use_lsp = true,
               -- Useful when using custom test names with @isTest annotation
               custom_test_method_names = {},
            },
         }
      })
   end,
}
