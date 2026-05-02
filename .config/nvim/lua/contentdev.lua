--[===[
ContentDev DSL support for filetypes, LSP and Tree-sitter.
--]===]

local M = {}

M.filetypes = {
   'contentdev_ddf',
   'contentdev_yaddl',
   'contentdev_help',
   'contentdev_dmscript',
}

local default_tools_root = '/Users/sven.bergner/Repos/SSE/Tools'
local default_compiler_dir = '/Users/sven.bergner/Repos/SSE/build/macos-compiler-release/lz'

M.tools_root = vim.env.CONTENTDEV_TOOLS_ROOT or default_tools_root
M.runtime_dir = vim.env.CONTENTDEV_NVIM_TS_RUNTIME or (vim.fn.stdpath('data') .. '/contentdev')
M.compiler_dir = vim.env.CONTENTDEV_COMPILER_DIR or default_compiler_dir
M.lsp_path = vim.env.CONTENTDEV_LSP or (M.compiler_dir .. '/contentdev-lsp')

M.languages = {
   {
      lang = 'contentdev_ddf',
      grammar = 'tree-sitter-ddf',
   },
   {
      lang = 'contentdev_yaddl',
      grammar = 'tree-sitter-yaddl',
   },
   {
      lang = 'contentdev_help',
      grammar = 'tree-sitter-help',
   },
   {
      lang = 'contentdev_dmscript',
      grammar = 'tree-sitter-dmscript',
   },
}

vim.filetype.add({
   extension = {
      ddf = 'contentdev_ddf',
      tdl = 'contentdev_ddf',
      yaddl = 'contentdev_yaddl',
      template = 'contentdev_yaddl',
      htd = 'contentdev_help',
      help = 'contentdev_help',
      cnv = 'contentdev_dmscript',
      frw = 'contentdev_dmscript',
      tst = 'contentdev_dmscript',
      ecf = 'contentdev_dmscript',
   },
   pattern = {
      ['.*/[Dd][Dd][Ff]/.*%.inc'] = 'contentdev_ddf',
      ['.*/[Tt][Dd][Ll]/.*%.inc'] = 'contentdev_ddf',
      ['.*/[Yy]addl/.*%.inc'] = 'contentdev_yaddl',
      ['.*/[Hh]elp/.*%.inc'] = 'contentdev_help',
   },
})

local function join(...)
   return table.concat({ ... }, '/')
end

local function grammar_dir(language)
   return join(M.tools_root, 'Compiler/tree-sitter', language.grammar)
end

local function runtimepath_contains(path)
   for _, value in ipairs(vim.opt.runtimepath:get()) do
      if value == path then
         return true
      end
   end

   return false
end

function M.ensure_runtimepath()
   if not runtimepath_contains(M.runtime_dir) then
      vim.opt.runtimepath:prepend(M.runtime_dir)
   end
end

M.ensure_runtimepath()

for _, filetype in ipairs(M.filetypes) do
   pcall(vim.treesitter.language.register, filetype, filetype)
end

local function resolve_root(bufnr)
   local path = vim.api.nvim_buf_get_name(bufnr)
   local normalized = path:gsub('\\', '/')
   local dm_source_root = normalized:match('^(.*[/]DMSource)/')

   if dm_source_root then
      return dm_source_root
   end

   local git_root = vim.fs.root(bufnr, { '.git' })
   if git_root then
      return git_root
   end

   if path ~= '' then
      return vim.fs.dirname(path)
   end

   return vim.fn.getcwd()
end

local function contentdev_root(bufnr, on_dir)
   on_dir(resolve_root(bufnr))
end

function M.configure_diagnostics(client, bufnr)
   if client.name ~= 'contentdev_lsp' then
      return
   end

   if not (vim.lsp and vim.lsp.diagnostic and vim.lsp.diagnostic.get_namespace) then
      return
   end

   local namespace = vim.lsp.diagnostic.get_namespace(client.id)
   vim.diagnostic.config({
      update_in_insert = true,
      virtual_text = {
         spacing = 2,
         source = true,
      },
   }, namespace)
   vim.diagnostic.show(namespace, bufnr)
end

function M.lsp_config()
   return {
      name = 'contentdev_lsp',
      cmd = { M.lsp_path },
      filetypes = M.filetypes,
      root_dir = contentdev_root,
      init_options = {
         compilerDir = M.compiler_dir,
         liveSyntaxDiagnostics = true,
         compilerDiagnosticsOnSave = true,
      },
      on_attach = M.configure_diagnostics,
      single_file_support = true,
   }
end

function M.start_lsp(bufnr)
   local config = M.lsp_config()
   config.root_dir = resolve_root(bufnr)
   vim.lsp.start(config, { bufnr = bufnr })
end

local tree_sitter_group = vim.api.nvim_create_augroup('contentdev_treesitter', { clear = true })
local lsp_group = vim.api.nvim_create_augroup('contentdev_lsp', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
   group = tree_sitter_group,
   pattern = M.filetypes,
   callback = function(args)
      M.ensure_runtimepath()
      pcall(vim.treesitter.start, args.buf)
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
   end,
})

vim.api.nvim_create_autocmd('FileType', {
   group = lsp_group,
   pattern = M.filetypes,
   callback = function(args)
      M.start_lsp(args.buf)
   end,
})

local function copy_queries(language, source_dir)
   local target_dir = join(M.runtime_dir, 'queries', language.lang)
   vim.fn.mkdir(target_dir, 'p')

   local query_files = vim.fn.glob(join(source_dir, 'queries', '*.scm'), false, true)
   for _, query_file in ipairs(query_files) do
      local target_file = join(target_dir, vim.fn.fnamemodify(query_file, ':t'))
      local ok, lines = pcall(vim.fn.readfile, query_file, 'b')

      if not ok then
         return false, 'Cannot read ' .. query_file
      end

      local write_ok = pcall(vim.fn.writefile, lines, target_file, 'b')
      if not write_ok then
         return false, 'Cannot write ' .. target_file
      end
   end

   return true
end

function M.install_treesitter()
   if vim.fn.executable('tree-sitter') ~= 1 then
      vim.notify('tree-sitter CLI not found in PATH', vim.log.levels.ERROR)
      return
   end

   M.ensure_runtimepath()
   vim.fn.mkdir(join(M.runtime_dir, 'parser'), 'p')

   local errors = {}

   for _, language in ipairs(M.languages) do
      local source_dir = grammar_dir(language)

      if vim.fn.isdirectory(source_dir) == 0 then
         table.insert(errors, 'Missing grammar directory: ' .. source_dir)
      else
         local parser_file = join(M.runtime_dir, 'parser', language.lang .. '.so')
         local result = vim.system({
            'tree-sitter',
            'build',
            '-o',
            parser_file,
            source_dir,
         }, { text = true }):wait()

         if result.code ~= 0 then
            table.insert(errors, result.stderr ~= '' and result.stderr or ('tree-sitter build failed for ' .. language.lang))
         else
            local ok, message = copy_queries(language, source_dir)
            if not ok then
               table.insert(errors, message)
            end
         end
      end
   end

   if #errors > 0 then
      vim.notify(table.concat(errors, '\n'), vim.log.levels.ERROR)
      return
   end

   vim.notify('ContentDev Tree-sitter parsers installed in ' .. M.runtime_dir, vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ContentDevInstallTreesitter', function()
   M.install_treesitter()
end, { desc = 'Build and install ContentDev Tree-sitter parsers' })

vim.api.nvim_create_user_command('ContentDevInfo', function()
   print(table.concat({
      'ContentDev LSP: ' .. M.lsp_path,
      'ContentDev compiler dir: ' .. M.compiler_dir,
      'ContentDev tools root: ' .. M.tools_root,
      'ContentDev Tree-sitter runtime: ' .. M.runtime_dir,
   }, '\n'))
end, { desc = 'Show ContentDev Neovim paths' })

local function enable_lsp()
   if vim.lsp and vim.lsp.config and vim.lsp.enable then
      pcall(vim.lsp.config, 'contentdev_lsp', M.lsp_config())
      pcall(vim.lsp.enable, 'contentdev_lsp')
   end
end

enable_lsp()

vim.api.nvim_create_autocmd('VimEnter', {
   group = lsp_group,
   callback = enable_lsp,
})

return M
