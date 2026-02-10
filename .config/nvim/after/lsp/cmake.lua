-- Language Server Protocol configuration for CMake
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cmake

return {
   cmd = { 'cmake-language-server' },
   filetypes = { 'cmake' },
   init_options = {
      buildDirectory = 'build',
   },
   root_markers = {
      'CMakePresets.json',
      'CTestConfig.cmake',
      '.git',
      'build',
      'cmake',
   },
}
