local M = {}

M.install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site')
M.cache_dir = vim.fs.joinpath(vim.fn.stdpath('cache'), 'treesitter')
M.registry_url = 'https://raw.githubusercontent.com/neovim-treesitter/treesitter-parser-registry/main/registry.json'

M.languages = {
   'bash',
   'c',
   'cmake',
   'cpp',
   'css',
   'csv',
   'dart',
   'diff',
   'dockerfile',
   'dtd',
   'ecma',
   'editorconfig',
   'elixir',
   'erlang',
   'git_config',
   'git_rebase',
   'gitattributes',
   'gitcommit',
   'gitignore',
   'go',
   'html',
   'html_tags',
   'http',
   'javascript',
   'jsx',
   'json',
   'kdl',
   'kotlin',
   'lua',
   'luadoc',
   'luap',
   'make',
   'markdown',
   'markdown_inline',
   'ninja',
   'nix',
   'python',
   'regex',
   'ruby',
   'rust',
   'toml',
   'tsv',
   'vim',
   'vimdoc',
   'xml',
   'yaml',
   'zsh',
}

local function notify(message, level)
   vim.notify(message, level or vim.log.levels.INFO, { title = 'treesitter' })
end

local function join(...)
   return vim.fs.joinpath(...)
end

local function ensure_dir(path)
   vim.fn.mkdir(path, 'p')
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
   if not runtimepath_contains(M.install_dir) then
      vim.opt.runtimepath:prepend(M.install_dir)
   end
end

local function system(args, opts)
   opts = opts or {}
   local result = vim.system(args, vim.tbl_extend('force', { text = true }, opts)):wait()
   if result.code ~= 0 then
      local message = result.stderr ~= '' and result.stderr or table.concat(args, ' ') .. ' failed'
      return false, vim.trim(message)
   end
   return true, result.stdout
end

local function copy_file(source, target)
   local ok, lines = pcall(vim.fn.readfile, source, 'b')
   if not ok then
      return false, 'Cannot read ' .. source
   end

   ensure_dir(vim.fs.dirname(target))
   ok = pcall(vim.fn.writefile, lines, target, 'b')
   if not ok then
      return false, 'Cannot write ' .. target
   end

   return true
end

local function copy_query_files(source_dir, target_dir)
   if vim.fn.isdirectory(source_dir) == 0 then
      return false, 'Missing query directory: ' .. source_dir
   end

   ensure_dir(target_dir)
   local files = vim.fn.glob(join(source_dir, '*.scm'), false, true)
   for _, source in ipairs(files) do
      local ok, message = copy_file(source, join(target_dir, vim.fn.fnamemodify(source, ':t')))
      if not ok then
         return false, message
      end
   end

   return true
end

local function clone_repo(url, target)
   vim.fn.delete(target, 'rf')
   ensure_dir(vim.fs.dirname(target))
   return system({ 'git', 'clone', '--depth', '1', url, target })
end

local function registry_path()
   return join(M.cache_dir, 'registry.json')
end

function M.load_registry(force)
   ensure_dir(M.cache_dir)
   local path = registry_path()

   if force or vim.fn.filereadable(path) == 0 then
      local ok, output = system({ 'curl', '-fsSL', M.registry_url })
      if not ok then
         if vim.fn.filereadable(path) == 1 then
            notify('Cannot refresh parser registry, using cached copy: ' .. output, vim.log.levels.WARN)
         else
            return nil, output
         end
      else
         local write_ok = pcall(vim.fn.writefile, vim.split(output, '\n', { plain = true }), path)
         if not write_ok then
            return nil, 'Cannot write parser registry cache: ' .. path
         end
      end
   end

   local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
   if not ok then
      return nil, 'Cannot decode parser registry: ' .. decoded
   end

   return decoded
end

local function normalize_languages(registry, languages)
   if not languages or #languages == 0 then
      languages = M.languages
   elseif #languages == 1 and languages[1] == 'all' then
      local all = {}
      for language, entry in pairs(registry) do
         if language ~= '$schema' and entry.source and entry.source.type ~= 'queries_only' then
            table.insert(all, language)
         end
      end
      table.sort(all)
      languages = all
   end

   local result = {}
   local seen = {}

   local function add(language)
      if seen[language] then
         return
      end
      seen[language] = true

      local entry = registry[language]
      if entry and entry.requires then
         for _, dependency in ipairs(entry.requires) do
            add(dependency)
         end
      end

      table.insert(result, language)
   end

   for _, language in ipairs(languages) do
      add(language)
   end

   return result
end

local function install_queries(language, entry, force)
   local source = entry.source
   local query_url = source.queries_url or source.url
   if not query_url then
      return false, 'No query source for ' .. language
   end

   local target_dir = join(M.install_dir, 'queries', language)
   if not force and vim.fn.isdirectory(target_dir) == 1 and #vim.fn.glob(join(target_dir, '*.scm'), false, true) > 0 then
      return true
   end

   local checkout = join(M.cache_dir, 'queries', language)
   local ok, message = clone_repo(query_url, checkout)
   if not ok then
      return false, message
   end

   local query_dir = source.queries_dir or source.queries_path or 'queries'
   return copy_query_files(join(checkout, query_dir), target_dir)
end

local function install_parser(language, entry, force)
   local source = entry.source
   local parser_url = source.parser_url or source.url
   if not parser_url then
      return true
   end

   local parser_file = join(M.install_dir, 'parser', language .. '.so')
   if not force and vim.fn.filereadable(parser_file) == 1 then
      return true
   end

   local checkout = join(M.cache_dir, 'parsers', language)
   local ok, message = clone_repo(parser_url, checkout)
   if not ok then
      return false, message
   end

   local source_dir = checkout
   if source.parser_location then
      source_dir = join(source_dir, source.parser_location)
   end

   ensure_dir(join(M.install_dir, 'parser'))
   return system({ 'tree-sitter', 'build', '-o', parser_file, source_dir })
end

function M.install(languages, opts)
   opts = opts or {}
   M.ensure_runtimepath()
   ensure_dir(join(M.install_dir, 'parser'))
   ensure_dir(join(M.install_dir, 'queries'))

   local registry, err = M.load_registry(opts.refresh_registry)
   if not registry then
      notify(err, vim.log.levels.ERROR)
      return false
   end

   local errors = {}
   for _, language in ipairs(normalize_languages(registry, languages)) do
      local entry = registry[language]
      if not entry or not entry.source then
         table.insert(errors, 'Unsupported language: ' .. language)
      elseif entry.source.type == 'queries_only' then
         local ok, message = install_queries(language, entry, opts.force)
         if not ok then
            table.insert(errors, language .. ': ' .. message)
         end
      elseif entry.source.type == 'external_queries' or entry.source.type == 'self_contained' then
         local ok, message = install_parser(language, entry, opts.force)
         if not ok then
            table.insert(errors, language .. ': ' .. message)
         else
            ok, message = install_queries(language, entry, opts.force)
            if not ok then
               table.insert(errors, language .. ': ' .. message)
            end
         end
      else
         table.insert(errors, language .. ': unsupported registry source type ' .. tostring(entry.source.type))
      end
   end

   if #errors > 0 then
      notify(table.concat(errors, '\n'), vim.log.levels.ERROR)
      return false
   end

   notify('Tree-sitter parsers and queries installed')
   return true
end

function M.uninstall(languages)
   for _, language in ipairs(languages or {}) do
      vim.fn.delete(join(M.install_dir, 'parser', language .. '.so'), 'rf')
      vim.fn.delete(join(M.install_dir, 'queries', language), 'rf')
   end
end

function M.installed()
   local result = {}
   local seen = {}

   for _, file in ipairs(vim.fn.glob(join(M.install_dir, 'parser', '*.*'), false, true)) do
      local language = vim.fn.fnamemodify(file, ':t:r')
      seen[language] = true
   end

   for _, dir in ipairs(vim.fn.glob(join(M.install_dir, 'queries', '*'), false, true)) do
      if vim.fn.isdirectory(dir) == 1 then
         seen[vim.fn.fnamemodify(dir, ':t')] = true
      end
   end

   for language, _ in pairs(seen) do
      table.insert(result, language)
   end
   table.sort(result)
   return result
end

local selection_stack = {}

local function set_selection(node, mode)
   local start_row, start_col, end_row, end_col = node:range()
   vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
   vim.cmd('normal! ' .. (mode or 'v'))
   vim.api.nvim_win_set_cursor(0, { end_row + 1, math.max(end_col - 1, 0) })
end

local function current_node()
   local ok, node = pcall(vim.treesitter.get_node)
   if ok then
      return node
   end
end

local function scope_node(bufnr)
   local ft = vim.bo[bufnr].filetype
   local lang = vim.treesitter.language.get_lang(ft)
   local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
   if not ok or not parser then
      return nil
   end

   local query = vim.treesitter.query.get(lang, 'locals')
   if not query then
      return nil
   end

   local cursor = vim.api.nvim_win_get_cursor(0)
   local row = cursor[1] - 1
   local col = cursor[2]
   local best

   parser:for_each_tree(function(tree)
      local root = tree:root()
      for id, node in query:iter_captures(root, bufnr, row, row + 1) do
         if query.captures[id] == 'local.scope' and vim.treesitter.is_in_node_range(node, row, col) then
            if not best or best:byte_length() > node:byte_length() then
               best = node
            end
         end
      end
   end)

   return best
end

function M.incremental_selection(kind)
   local bufnr = vim.api.nvim_get_current_buf()
   local node

   if kind == 'scope' then
      node = scope_node(bufnr)
   end

   if not node then
      local stack = selection_stack[bufnr] or {}
      node = stack[#stack]
      node = node and node:parent() or current_node()
   end

   if not node then
      return
   end

   selection_stack[bufnr] = selection_stack[bufnr] or {}
   table.insert(selection_stack[bufnr], node)
   set_selection(node, 'v')
end

function M.decremental_selection()
   local bufnr = vim.api.nvim_get_current_buf()
   local stack = selection_stack[bufnr]
   if not stack or #stack == 0 then
      return
   end

   table.remove(stack)
   local node = stack[#stack]
   if node then
      set_selection(node, 'v')
   else
      vim.cmd('normal! v')
   end
end

function M.setup()
   M.ensure_runtimepath()

   vim.opt.foldmethod = 'expr'
   vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
   vim.opt.foldlevel = 99
   vim.opt.foldlevelstart = 99
   vim.opt.foldcolumn = '1'
   vim.opt.sessionoptions:remove('folds')

   vim.keymap.set('n', '<CR>', 'za', { noremap = true, silent = true, desc = 'Toggle current fold' })
   vim.keymap.set({ 'n', 'x' }, '<C-Enter>', function()
      require('treesitter').incremental_selection('node')
   end, { desc = 'Increment treesitter selection' })
   vim.keymap.set({ 'n', 'x' }, '<S-Enter>', function()
      require('treesitter').incremental_selection('scope')
   end, { desc = 'Increment treesitter scope selection' })
   vim.keymap.set('x', '<Backspace>', function()
      require('treesitter').decremental_selection()
   end, { desc = 'Decrement treesitter selection' })

   pcall(vim.treesitter.language.register, 'markdown', 'vimwiki')

   vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('local_treesitter', { clear = true }),
      callback = function(args)
         local lang = vim.treesitter.language.get_lang(args.match)
         if not lang then
            return
         end

         local ok, has_language = pcall(vim.treesitter.language.add, lang)
         if not ok or not has_language then
            return
         end

         pcall(vim.treesitter.start, args.buf, lang)
         vim.wo.foldmethod = 'expr'
         vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
         vim.bo[args.buf].indentexpr = "v:lua.require'treesitter.indent'.indentexpr()"
      end,
   })

   vim.api.nvim_create_user_command('TSInstall', function(opts)
      M.install(opts.fargs, { force = opts.bang })
   end, { nargs = '*', bang = true, complete = function()
      return M.languages
   end, desc = 'Install Tree-sitter parsers and queries' })

   vim.api.nvim_create_user_command('TSUpdate', function(opts)
      M.install(opts.fargs, { force = true, refresh_registry = opts.bang })
   end, { nargs = '*', bang = true, complete = function()
      return M.languages
   end, desc = 'Update Tree-sitter parsers and queries' })

   vim.api.nvim_create_user_command('TSUninstall', function(opts)
      M.uninstall(opts.fargs)
   end, { nargs = '+', complete = function()
      return M.installed()
   end, desc = 'Uninstall Tree-sitter parsers and queries' })

   vim.api.nvim_create_user_command('TSStatus', function()
      vim.cmd('new')
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
      vim.bo.swapfile = false
      vim.api.nvim_buf_set_lines(0, 0, -1, false, M.installed())
      vim.bo.filetype = 'text'
   end, { desc = 'Show installed Tree-sitter languages' })
end

return M
