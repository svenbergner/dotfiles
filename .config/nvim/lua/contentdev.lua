--[===[
ContentDev DSL support for filetypes, LSP and Tree-sitter.
--]===]

local M = {}
local list_unpack = table.unpack or unpack

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
M.output_state_path = vim.fn.stdpath('state') .. '/contentdev/output-dirs.json'
M.root_state_path = vim.fn.stdpath('state') .. '/contentdev/root-targets.json'

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

local function strip(value)
   return (value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function lower(value)
   return string.lower(value or '')
end

local function normalize_path(path)
   if path == nil or path == '' then
      return ''
   end

   local expanded = vim.fn.expand(path)
   local normalized = vim.fn.fnamemodify(expanded, ':p')
   normalized = normalized:gsub('\\', '/')
   normalized = normalized:gsub('/+$', '')
   return normalized
end

local function basename(path)
   return vim.fn.fnamemodify(path, ':t')
end

local function dirname(path)
   return vim.fn.fnamemodify(path, ':h')
end

local function path_exists(path)
   return path ~= nil and path ~= '' and vim.uv.fs_stat(path) ~= nil
end

local function file_readable(path)
   return path ~= nil and path ~= '' and vim.fn.filereadable(path) == 1
end

local function short_hash(value)
   if vim.fn.exists('*sha256') == 1 then
      return vim.fn.sha256(value):sub(1, 12)
   end

   local hash = 0
   for i = 1, #value do
      hash = (hash * 31 + value:byte(i)) % 4294967296
   end
   return string.format('%08x', hash)
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

function M.root_for_buffer(bufnr)
   return normalize_path(resolve_root(bufnr or 0))
end

function M.is_contentdev_filetype(filetype)
   for _, contentdev_filetype in ipairs(M.filetypes) do
      if filetype == contentdev_filetype then
         return true
      end
   end

   return false
end

function M.is_contentdev_buffer(bufnr)
   bufnr = bufnr or 0
   return M.is_contentdev_filetype(vim.bo[bufnr].filetype)
end

local build_languages = {
   contentdev_ddf = {
      name = 'DDF',
      dsl = 'ddf',
      exe = 'ddfC',
      env = 'CONTENTDEV_DDFC',
      meta_dir = 'ddf',
      output_dir = 'ddf',
      output_ext = 'ddb',
      source_dirs = { 'ddf', 'tdl' },
      root_exts = { ddf = true, tdl = true },
      include_exts = { inc = true },
      root_names = { 'Normal.ddf', 'normal.ddf' },
   },
   contentdev_yaddl = {
      name = 'YADDL',
      dsl = 'yaddl',
      exe = 'yaddlc',
      env = 'CONTENTDEV_YADDLC',
      meta_dir = 'yaddl',
      output_dir = 'Dialogs',
      output_ext = 'dialog',
      source_dirs = { 'Yaddl' },
      root_exts = { yaddl = true },
      include_exts = { template = true },
   },
   contentdev_help = {
      name = 'Help',
      dsl = 'help',
      exe = 'htmlC',
      env = 'CONTENTDEV_HTMLC',
      meta_dir = 'Help',
      output_dir = 'help',
      output_ext = 'htb',
      source_dirs = { 'Help' },
      root_exts = { htd = true, help = true },
      include_exts = { inc = true },
      root_globs = { '*.htd', '*.help' },
   },
   contentdev_dmscript = {
      name = 'DMScript',
      dsl = 'dmscript',
      exe = 'DMScriptC',
      env = 'CONTENTDEV_DMSCRIPTC',
      meta_dir = 'DMScript',
      source_dirs = { 'cnv', 'frw', 'test', 'elster' },
      output_dirs_by_script = {
         CONVERT = 'cnv',
         PRINT = 'frw',
         TEST = 'test',
         ELSTER = 'elster',
      },
      output_exts_by_script = {
         CONVERT = 'cnv',
         PRINT = 'frw',
         TEST = 'tst',
         ELSTER = 'edf',
      },
      root_exts = { cnv = true, frw = true, tst = true, ecf = true },
      include_exts = {},
   },
}

local function load_json_state(path)
   if vim.fn.filereadable(path) ~= 1 then
      return {}
   end

   local ok, lines = pcall(vim.fn.readfile, path)
   if not ok then
      return {}
   end

   local text = table.concat(lines, '\n')
   if strip(text) == '' then
      return {}
   end

   local decode_ok, decoded = pcall(vim.json.decode, text)
   if decode_ok and type(decoded) == 'table' then
      return decoded
   end

   return {}
end

local function save_json_state(path, state)
   vim.fn.mkdir(dirname(path), 'p')
   local ok, encoded = pcall(vim.json.encode, state)
   if not ok then
      vim.notify('ContentDev state could not be encoded: ' .. path, vim.log.levels.ERROR)
      return false
   end

   local write_ok = pcall(vim.fn.writefile, { encoded }, path)
   if not write_ok then
      vim.notify('ContentDev state could not be written: ' .. path, vim.log.levels.ERROR)
      return false
   end

   return true
end

local output_state = nil

local function load_output_state()
   if output_state == nil then
      output_state = load_json_state(M.output_state_path)
   end

   return output_state
end

local function save_output_state()
   return save_json_state(M.output_state_path, load_output_state())
end

local root_state = nil

local function load_root_state()
   if root_state == nil then
      root_state = load_json_state(M.root_state_path)
   end

   return root_state
end

local function save_root_state()
   return save_json_state(M.root_state_path, load_root_state())
end

local function default_output_dir(root)
   local root_name = basename(root)
   if root_name == '' then
      root_name = 'contentdev'
   end

   return normalize_path(join(vim.fn.stdpath('cache'), 'contentdev-build', root_name .. '-' .. short_hash(root)))
end

local function persisted_output_dir(root)
   local state = load_output_state()
   return state[normalize_path(root)]
end

local function set_persisted_output_dir(root, output_dir)
   local normalized_root = normalize_path(root)
   local normalized_output_dir = normalize_path(output_dir)
   if normalized_root == '' or normalized_output_dir == '' then
      return false
   end

   local state = load_output_state()
   state[normalized_root] = normalized_output_dir
   return save_output_state()
end

local function root_target_key(root, source)
   return normalize_path(root) .. '|' .. normalize_path(source)
end

local function persisted_root_target(root, source)
   local target = load_root_state()[root_target_key(root, source)]
   if target and file_readable(target) then
      return normalize_path(target)
   end

   return nil
end

local function set_persisted_root_target(root, source, target)
   local normalized_target = normalize_path(target)
   if not file_readable(normalized_target) then
      vim.notify('ContentDev root file does not exist: ' .. normalized_target, vim.log.levels.ERROR)
      return false
   end

   local state = load_root_state()
   state[root_target_key(root, source)] = normalized_target
   return save_root_state()
end

function M.output_dir_for_root(root)
   root = normalize_path(root)
   if vim.g.contentdev_output_dir and vim.g.contentdev_output_dir ~= '' then
      return normalize_path(vim.g.contentdev_output_dir)
   end
   if vim.env.CONTENTDEV_OUTPUT_DIR and vim.env.CONTENTDEV_OUTPUT_DIR ~= '' then
      return normalize_path(vim.env.CONTENTDEV_OUTPUT_DIR)
   end

   return persisted_output_dir(root)
end

local function resolve_output_dir(root, callback)
   local configured = M.output_dir_for_root(root)
   if configured and configured ~= '' then
      callback(configured)
      return
   end

   local default_dir = default_output_dir(root)
   vim.ui.input({
      prompt = 'ContentDev output base directory for ' .. root .. ': ',
      default = default_dir,
      completion = 'dir',
   }, function(input)
      input = strip(input)
      if input == '' then
         vim.notify('ContentDev build cancelled: no output directory selected.', vim.log.levels.WARN)
         return
      end

      local output_dir = normalize_path(input)
      if set_persisted_output_dir(root, output_dir) then
         vim.notify('ContentDev output base directory saved for ' .. root .. ': ' .. output_dir, vim.log.levels.INFO)
      end
      callback(output_dir)
   end)
end

function M.set_output_dir_for_current_root(path)
   local bufnr = vim.api.nvim_get_current_buf()
   if not M.is_contentdev_buffer(bufnr) then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   local root = M.root_for_buffer(bufnr)
   local function persist(output_dir)
      if set_persisted_output_dir(root, output_dir) then
         vim.notify('ContentDev output base directory set for ' .. root .. ': ' .. normalize_path(output_dir), vim.log.levels.INFO)
      end
   end

   if path and strip(path) ~= '' then
      persist(path)
      return
   end

   vim.ui.input({
      prompt = 'ContentDev output base directory for ' .. root .. ': ',
      default = M.output_dir_for_root(root) or default_output_dir(root),
      completion = 'dir',
   }, function(input)
      input = strip(input)
      if input ~= '' then
         persist(input)
      end
   end)
end

local function compiler_for_language(language)
   if vim.env[language.env] and vim.env[language.env] ~= '' then
      return normalize_path(vim.env[language.env])
   end

   local exe = language.exe
   if (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) and not exe:match('%.exe$') then
      exe = exe .. '.exe'
   end

   local candidate = normalize_path(join(M.compiler_dir, exe))
   if file_readable(candidate) then
      return candidate
   end

   return exe
end

local function file_extension(path)
   return lower(vim.fn.fnamemodify(path, ':e'))
end

local function is_include_file(path, language)
   return language.include_exts[file_extension(path)] == true
end

local function is_root_file(path, language)
   return language.root_exts[file_extension(path)] == true
end

local function source_base_from_root(root)
   local normalized = normalize_path(root)
   if normalized:match('/DMSource$') then
      return normalized
   end

   local marker = normalized:find('/DMSource/')
   if marker then
      return normalized:sub(1, marker + #'/DMSource' - 1)
   end

   return normalized
end

local function dependency_root_for_include(path, root, language)
   local source_base = source_base_from_root(root)
   local dependency_dir = normalize_path(join(vim.fn.fnamemodify(source_base, ':h'), 'MetaFiles', 'Dependencies', language.dsl))
   local filename = basename(path)
   local candidates = {
      join(dependency_dir, filename .. '.dep'),
      join(dependency_dir, lower(filename) .. '.dep'),
   }

   local source_dir = join(source_base, language.source_dirs[1] or '')
   for _, dep_file in ipairs(candidates) do
      if file_readable(dep_file) then
         local ok, lines = pcall(vim.fn.readfile, dep_file)
         if ok then
            for _, line in ipairs(lines) do
               line = strip(line)
               if line ~= '' then
                  local root_candidates = {
                     normalize_path(join(source_dir, line)),
                     normalize_path(join(dirname(path), line)),
                     normalize_path(join(source_base, line)),
                  }
                  for _, candidate in ipairs(root_candidates) do
                     if file_readable(candidate) and is_root_file(candidate, language) then
                        return candidate
                     end
                  end
               end
            end
         end
      end
   end

   return nil
end

local function include_target_matches(include_name, target)
   local normalized_include = include_name:gsub('\\', '/')
   return lower(basename(normalized_include)) == lower(basename(target))
end

local function file_in_language_source(path, language)
   local ext = file_extension(path)
   if not language.root_exts[ext] then
      return false
   end

   return true
end

local function reverse_include_roots(path, root, language)
   local source_base = source_base_from_root(root)
   local matches = {}
   local seen = {}

   for _, source_dir_name in ipairs(language.source_dirs) do
      local source_dir = normalize_path(join(source_base, source_dir_name))
      if path_exists(source_dir) then
         local files = vim.fn.globpath(source_dir, '**/*', false, true)
         for _, candidate in ipairs(files) do
            candidate = normalize_path(candidate)
            if file_readable(candidate) and file_in_language_source(candidate, language) then
               local ok, lines = pcall(vim.fn.readfile, candidate)
               if ok then
                  for _, line in ipairs(lines) do
                     local include_name = line:match('^%s*#[Ii][Nn][Cc][Ll][Uu][Dd][Ee]%s+"([^"]+)"')
                     if include_name and include_target_matches(include_name, path) and not seen[candidate] then
                        table.insert(matches, candidate)
                        seen[candidate] = true
                        break
                     end
                  end
               end
            end
         end
      end
   end

   table.sort(matches)
   return matches
end

local function relative_to_root(path, root)
   local normalized_path = normalize_path(path)
   local normalized_root = normalize_path(root)
   if normalized_path:sub(1, #normalized_root + 1) == normalized_root .. '/' then
      return normalized_path:sub(#normalized_root + 2)
   end

   return normalized_path
end

local function add_root_candidate(candidates, seen, root, path, label)
   path = normalize_path(path)
   if path == '' or not file_readable(path) then
      return
   end

   local real_path = vim.uv.fs_realpath(path)
   local seen_key = normalize_path(real_path or path)
   if seen[seen_key] then
      return
   end

   seen[seen_key] = true
   table.insert(candidates, {
      path = path,
      label = label or relative_to_root(path, root),
   })
end

local function root_candidates_for_path(path, root, language)
   local candidates = {}
   local seen = {}

   add_root_candidate(candidates, seen, root, path, 'Current file: ' .. relative_to_root(path, root))

   local dependency_root = dependency_root_for_include(path, root, language)
   if dependency_root then
      add_root_candidate(candidates, seen, root, dependency_root, 'Dependency root: ' .. relative_to_root(dependency_root, root))
   end

   for _, parent in ipairs(reverse_include_roots(path, root, language)) do
      add_root_candidate(candidates, seen, root, parent, 'Including file: ' .. relative_to_root(parent, root))
   end

   local source_base = source_base_from_root(root)
   for _, source_dir_name in ipairs(language.source_dirs) do
      for _, root_name in ipairs(language.root_names or {}) do
         add_root_candidate(candidates, seen, root, join(source_base, source_dir_name, root_name), 'Known root: ' .. source_dir_name .. '/' .. root_name)
      end

      for _, root_glob in ipairs(language.root_globs or {}) do
         local root_files = vim.fn.globpath(join(source_base, source_dir_name), root_glob, false, true)
         table.sort(root_files)
         for _, root_file in ipairs(root_files) do
            add_root_candidate(candidates, seen, root, root_file, 'Known root: ' .. relative_to_root(root_file, root))
         end
      end
   end

   return candidates
end

local function choose_root_file(root, source, language, candidates, callback)
   local manual = {
      label = 'Choose another root file...',
      path = nil,
      manual = true,
   }

   table.insert(candidates, manual)
   vim.ui.select(candidates, {
      prompt = 'ContentDev root file for ' .. relative_to_root(source, root) .. ':',
      format_item = function(item)
         return item.label
      end,
   }, function(choice)
      if not choice then
         callback(nil, 'No root file selected.')
         return
      end

      if choice.manual then
         vim.ui.input({
            prompt = 'ContentDev root file: ',
            default = normalize_path(join(source_base_from_root(root), language.source_dirs[1] or '', basename(source))),
            completion = 'file',
         }, function(input)
            input = strip(input)
            if input == '' then
               callback(nil, 'No root file selected.')
               return
            end

            local target = normalize_path(input)
            if not file_readable(target) then
               callback(nil, 'Root file does not exist: ' .. target)
               return
            end

            set_persisted_root_target(root, source, target)
            callback(target)
         end)
         return
      end

      set_persisted_root_target(root, source, choice.path)
      callback(choice.path)
   end)
end

local function should_ask_for_root(path, language, candidates)
   if is_include_file(path, language) then
      return true
   end

   if #candidates <= 1 then
      return false
   end

   for _, candidate in ipairs(candidates) do
      if normalize_path(candidate.path) ~= normalize_path(path) then
         return true
      end
   end

   return false
end

local function resolve_target_for_buffer(bufnr, language, force_select, callback)
   local path = normalize_path(vim.api.nvim_buf_get_name(bufnr))
   if path == '' then
      callback(nil, 'Current buffer has no file name.')
      return
   end

   local root = M.root_for_buffer(bufnr)
   if not force_select then
      local persisted_target = persisted_root_target(root, path)
      if persisted_target then
         callback(persisted_target)
         return
      end
   end

   local candidates = root_candidates_for_path(path, root, language)
   if force_select or should_ask_for_root(path, language, candidates) then
      choose_root_file(root, path, language, candidates, callback)
      return
   end

   for _, candidate in ipairs(candidates) do
      if normalize_path(candidate.path) == path then
         callback(path)
         return
      end
   end

   if #candidates > 0 then
      set_persisted_root_target(root, path, candidates[1].path)
      callback(candidates[1].path)
      return
   end

   callback(nil, 'No root file found for ' .. path)
end

local function dmscript_type_for_path(path)
   local normalized = '/' .. lower(normalize_path(path)) .. '/'
   local ext = file_extension(path)
   if ext == 'cnv' or normalized:find('/cnv/', 1, true) then
      return 'CONVERT'
   end
   if ext == 'frw' or normalized:find('/frw/', 1, true) then
      return 'PRINT'
   end
   if ext == 'tst' or normalized:find('/test/', 1, true) then
      return 'TEST'
   end
   if ext == 'ecf' or normalized:find('/elster/', 1, true) then
      return 'ELSTER'
   end

   return nil
end

local function relative_to_source_base(path, root)
   local source_base = source_base_from_root(root)
   local normalized_path = normalize_path(path)
   if normalized_path:sub(1, #source_base + 1) == source_base .. '/' then
      return normalized_path:sub(#source_base + 2)
   end

   return basename(path)
end

local function parent_dir_or_empty(path)
   local dir = dirname(path)
   if dir == '.' then
      return ''
   end

   return dir
end

local function language_output_dir(language, target, output_base_dir, root)
   local output_parts = { output_base_dir }

   if language.dsl == 'dmscript' then
      local script_type = dmscript_type_for_path(target)
      local base_dir = language.output_dirs_by_script and language.output_dirs_by_script[script_type]
      local relative = relative_to_source_base(target, root)
      local relative_dir = parent_dir_or_empty(relative)

      if base_dir then
         table.insert(output_parts, base_dir)
         local nested_dir = relative_dir:gsub('^[^/]+/?', '')
         if nested_dir ~= '' then
            table.insert(output_parts, nested_dir)
         end
      elseif relative_dir ~= '' then
         table.insert(output_parts, relative_dir)
      end
   elseif language.output_dir then
      table.insert(output_parts, language.output_dir)
   end

   return normalize_path(join(list_unpack(output_parts)))
end

local function language_output_ext(language, target)
   if language.dsl == 'dmscript' then
      local script_type = dmscript_type_for_path(target)
      return language.output_exts_by_script and language.output_exts_by_script[script_type]
   end

   return language.output_ext
end

local function language_output_file(language, target, output_base_dir, root)
   local out_dir = language_output_dir(language, target, output_base_dir, root)
   local output_ext = language_output_ext(language, target)
   if output_ext == nil or output_ext == '' then
      return out_dir
   end

   local output_name = lower(vim.fn.fnamemodify(target, ':t:r')) .. '.' .. output_ext
   return normalize_path(join(out_dir, output_name))
end

local function name_table_file(output_base_dir)
   return normalize_path(join(output_base_dir, 'ddf', 'nametbl.ndx'))
end

local function append_common_compiler_context(args, language, target, output_base_dir)
   local include_dir = dirname(target)
   if include_dir ~= '' and include_dir ~= '.' then
      table.insert(args, '-I' .. normalize_path(include_dir))
   end

   local name_table = name_table_file(output_base_dir)
   if language.dsl == 'ddf' then
      vim.fn.mkdir(dirname(name_table), 'p')
      if file_readable(name_table) then
         table.insert(args, '-XN' .. name_table)
      end
      table.insert(args, '-W' .. name_table)
   elseif file_readable(name_table) then
      table.insert(args, '-XN' .. name_table)
   end

   if language.dsl == 'help' then
      local source_base = source_base_from_root(target)
      local common_defs = normalize_path(join(source_base, 'ddf', 'CommonDefs.def'))
      if file_readable(common_defs) then
         table.insert(args, '@' .. common_defs)
      end
      table.insert(args, '-d')
      table.insert(args, '-DQS_ENABLED=~T')
      table.insert(args, '-DModus=0')
   end
end

local function build_args(language, target, output_base_dir, root)
   local out_dir = language_output_dir(language, target, output_base_dir, root)
   local out_file = language_output_file(language, target, output_base_dir, root)
   local meta_dir = normalize_path(join(output_base_dir, 'MetaFiles', language.meta_dir))
   local help_dependency_dir = nil
   vim.fn.mkdir(out_dir, 'p')
   vim.fn.mkdir(meta_dir, 'p')
   if language.dsl == 'help' then
      help_dependency_dir = normalize_path(join(output_base_dir, 'MetaFiles', 'Dependencies', 'Help'))
      vim.fn.mkdir(help_dependency_dir, 'p')
   end

   local args = { compiler_for_language(language) }
   append_common_compiler_context(args, language, target, output_base_dir)

   if language.dsl == 'dmscript' then
      local script_type = dmscript_type_for_path(target)
      if not script_type then
         return nil, 'Cannot determine DMScript --scriptType for ' .. target
      end
      vim.list_extend(args, { '--scriptType', script_type })
   end

   vim.list_extend(args, {
      target,
      '--continueAfterError',
      '--usePortableUserInput',
      '-o' .. out_file,
      '-l' .. meta_dir,
   })

   if language.dsl == 'help' then
      table.insert(args, '-i' .. help_dependency_dir)
      local source_base = source_base_from_root(target)
      local known_commands = normalize_path(join(dirname(source_base), 'MetaFiles', 'SSE', 'KnownCommands.txt'))
      if file_readable(known_commands) then
         vim.list_extend(args, { '--checkCommands', known_commands })
      end
   end

   return args, nil, out_file
end

local function split_output_lines(output)
   local lines = {}
   output = output or ''
   for line in (output .. '\n'):gmatch('(.-)\n') do
      if line ~= '' then
         table.insert(lines, line)
      end
   end
   return lines
end

local function quickfix_items(output, fallback_file)
   local items = {}
   local severity = {
      ['Fehler'] = 'E',
      ['Warnung'] = 'W',
      ['TODO'] = 'I',
      ['Info'] = 'I',
   }

   for _, line in ipairs(split_output_lines(output)) do
      local filename, lnum, col, kind, text = line:match('^(.-) Line (%d+)%((%d+)%)%: ([^:]+)%: (.*)$')
      if filename then
         table.insert(items, {
            filename = normalize_path(filename),
            lnum = tonumber(lnum),
            col = tonumber(col),
            type = severity[kind] or 'E',
            text = text,
         })
      else
         table.insert(items, {
            filename = fallback_file,
            lnum = 1,
            col = 1,
            type = 'I',
            text = line,
         })
      end
   end

   return items
end

local current_build = nil

local function finish_build(language, target, output_dir, result)
   current_build = nil
   local output = table.concat({ result.stdout or '', result.stderr or '' }, '\n')
   local items = quickfix_items(output, target)
   local title = 'ContentDev ' .. language.name .. ' build: ' .. basename(target)

   if #items == 0 then
      table.insert(items, {
         filename = target,
         lnum = 1,
         col = 1,
         type = result.code == 0 and 'I' or 'E',
         text = result.code == 0 and 'ContentDev build finished without compiler output.' or 'ContentDev build failed without compiler output.',
      })
   end

   vim.fn.setqflist({}, 'r', {
      title = title,
      items = items,
   })

   local has_error = result.code ~= 0
   for _, item in ipairs(items) do
      if item.type == 'E' then
         has_error = true
         break
      end
   end

   if has_error then
      vim.cmd('copen')
      vim.notify(title .. ' failed.', vim.log.levels.ERROR)
      return
   end

   vim.cmd('cclose')
   vim.notify(title .. ' succeeded. Output: ' .. output_dir, vim.log.levels.INFO)
end

function M.build_current_buffer()
   local bufnr = vim.api.nvim_get_current_buf()
   local language = build_languages[vim.bo[bufnr].filetype]
   if not language then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   if current_build and current_build.kill then
      pcall(function()
         current_build:kill(15)
      end)
      current_build = nil
   end

   local root = M.root_for_buffer(bufnr)
   resolve_target_for_buffer(bufnr, language, false, function(target, target_error)
      if not target then
         vim.notify('ContentDev build cancelled: ' .. target_error, vim.log.levels.ERROR)
         return
      end

      resolve_output_dir(root, function(output_dir)
         local args, args_error, out_dir = build_args(language, target, output_dir, root)
         if not args then
            vim.notify('ContentDev build cancelled: ' .. args_error, vim.log.levels.ERROR)
            return
         end

         if vim.fn.executable(args[1]) ~= 1 then
            vim.notify('ContentDev compiler not executable: ' .. args[1], vim.log.levels.ERROR)
            return
         end

         vim.cmd('cclose')
         vim.notify('ContentDev ' .. language.name .. ' build started: ' .. target, vim.log.levels.INFO)
         current_build = vim.system(args, { text = true }, function(result)
            vim.schedule(function()
               finish_build(language, target, out_dir, result)
            end)
         end)
      end)
   end)
end

function M.select_root_for_current_buffer()
   local bufnr = vim.api.nvim_get_current_buf()
   local language = build_languages[vim.bo[bufnr].filetype]
   if not language then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   resolve_target_for_buffer(bufnr, language, true, function(target, target_error)
      if target then
         vim.notify('ContentDev root file set: ' .. target, vim.log.levels.INFO)
      else
         vim.notify('ContentDev root file not changed: ' .. target_error, vim.log.levels.WARN)
      end
   end)
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

vim.api.nvim_create_user_command('ContentDevBuild', function()
   M.build_current_buffer()
end, { desc = 'Build the current ContentDev buffer' })

vim.api.nvim_create_user_command('ContentDevSetOutputDir', function(opts)
   M.set_output_dir_for_current_root(opts.args)
end, {
   nargs = '?',
   complete = 'dir',
   desc = 'Set the ContentDev output base directory for the current ContentDev root',
})

vim.api.nvim_create_user_command('ContentDevSelectRootFile', function()
   M.select_root_for_current_buffer()
end, { desc = 'Select the ContentDev root file for the current source file' })

vim.api.nvim_create_user_command('ContentDevInfo', function()
   local root = M.root_for_buffer(0)
   local output_dir = M.output_dir_for_root(root) or '(not set)'
   local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
   local root_file = persisted_root_target(root, current_file) or '(not set)'
   print(table.concat({
      'ContentDev LSP: ' .. M.lsp_path,
      'ContentDev compiler dir: ' .. M.compiler_dir,
      'ContentDev output base dir: ' .. output_dir,
      'ContentDev selected root file: ' .. root_file,
      'ContentDev tools root: ' .. M.tools_root,
      'ContentDev root: ' .. root,
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
