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
M.compiler_meta_dir_flag = vim.env.CONTENTDEV_COMPILER_META_DIR_FLAG
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
      DDF = 'contentdev_ddf',
      tdl = 'contentdev_ddf',
      TDL = 'contentdev_ddf',
      yaddl = 'contentdev_yaddl',
      template = 'contentdev_yaddl',
      htd = 'contentdev_help',
      help = 'contentdev_help',
      cnv = 'contentdev_dmscript',
      frw = 'contentdev_dmscript',
      FRW = 'contentdev_dmscript',
      tst = 'contentdev_dmscript',
      ecf = 'contentdev_dmscript',
   },
   pattern = {
      ['.*/[Dd][Dd][Ff]/.*%.inc'] = 'contentdev_ddf',
      ['.*/[Tt][Dd][Ll]/.*%.inc'] = 'contentdev_ddf',
      ['.*/[Ff][Rr][Ww]/.*%.inc'] = 'contentdev_dmscript',
      ['.*/[Yy]addl/.*%.inc'] = 'contentdev_yaddl',
      ['.*/[Hh]elp/.*%.inc'] = 'contentdev_help',
   },
})

-- Normalize filetypes restored by older sessions.  In particular, sessions
-- containing the historic typo `content_dmcript` would otherwise bypass the
-- ContentDev build path and make <F7> start a CMake build instead.
local legacy_filetypes = {
   content_ddf = 'contentdev_ddf',
   content_yaddl = 'contentdev_yaddl',
   content_help = 'contentdev_help',
   content_dmscript = 'contentdev_dmscript',
   content_dmcript = 'contentdev_dmscript',
}

vim.api.nvim_create_autocmd('FileType', {
   pattern = vim.tbl_keys(legacy_filetypes),
   ---Replace a legacy ContentDev filetype with its current name.
   ---@param args table Autocommand event data containing the buffer number.
   callback = function(args)
      vim.bo[args.buf].filetype = legacy_filetypes[vim.bo[args.buf].filetype]
   end,
})

---Join path components with forward slashes.
---@param ... string
---@return string
local function join(...)
   return table.concat({ ... }, '/')
end

---Remove leading and trailing whitespace from a value.
---@param value? string
---@return string
local function strip(value)
   return ((value or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

---Convert a value to lowercase, treating nil as an empty string.
---@param value? string
---@return string
local function lower(value)
   return string.lower(value or '')
end

---Expand and normalize a path without a trailing slash.
---@param path? string
---@return string
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

---Return the final component of a path.
---@param path string
---@return string
local function basename(path)
   return vim.fn.fnamemodify(path, ':t')
end

---Return the directory containing a path.
---@param path string
---@return string
local function dirname(path)
   return vim.fn.fnamemodify(path, ':h')
end

---Check whether a filesystem entry exists.
---@param path? string
---@return boolean
local function path_exists(path)
   return path ~= nil and path ~= '' and vim.uv.fs_stat(path) ~= nil
end

---Check whether a path names a readable file.
---@param path? string
---@return boolean
local function file_readable(path)
   return path ~= nil and path ~= '' and vim.fn.filereadable(path) == 1
end

---Create a short stable hash for use in generated directory names.
---@param value string
---@return string
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

---Resolve the source directory of a configured Tree-sitter grammar.
---@param language table ContentDev language descriptor.
---@return string
local function grammar_dir(language)
   return join(M.tools_root, 'Compiler/tree-sitter', language.grammar)
end

local source_base_from_root
local stp_major_from_root
local tools_root_for_root
local compiler_dir_for_root
local lsp_path_for_root

---Check whether a path is already present in Neovim's runtimepath.
---@param path string
---@return boolean
local function runtimepath_contains(path)
   for _, value in ipairs(vim.opt.runtimepath:get()) do
      if value == path then
         return true
      end
   end

   return false
end

---Add the generated ContentDev runtime directory to runtimepath if needed.
function M.ensure_runtimepath()
   if not runtimepath_contains(M.runtime_dir) then
      vim.opt.runtimepath:prepend(M.runtime_dir)
   end
end

M.ensure_runtimepath()

for _, filetype in ipairs(M.filetypes) do
   pcall(vim.treesitter.language.register, filetype, filetype)
end

---Resolve the ContentDev project root for a buffer.
---@param bufnr integer Neovim buffer number.
---@return string
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

---Pass the resolved buffer root to an LSP root-directory callback.
---@param bufnr integer Neovim buffer number.
---@param on_dir fun(root: string)
local function contentdev_root(bufnr, on_dir)
   on_dir(resolve_root(bufnr))
end

---Return the normalized ContentDev project root for a buffer.
---@param bufnr? integer Defaults to the current buffer.
---@return string
function M.root_for_buffer(bufnr)
   return normalize_path(resolve_root(bufnr or 0))
end

---Check whether a filetype belongs to one of the ContentDev DSLs.
---@param filetype string
---@return boolean
function M.is_contentdev_filetype(filetype)
   for _, contentdev_filetype in ipairs(M.filetypes) do
      if filetype == contentdev_filetype then
         return true
      end
   end

   return false
end

---Check whether a buffer uses a ContentDev filetype.
---@param bufnr? integer Defaults to the current buffer.
---@return boolean
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

---Read a JSON object from disk, returning an empty table on failure.
---@param path string
---@return table
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

---Encode and persist a state table as JSON.
---@param path string
---@param state table
---@return boolean success
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
local output_dir_history_key = '__history'

---Load and cache the per-project output-directory state.
---@return table
local function load_output_state()
   if output_state == nil then
      output_state = load_json_state(M.output_state_path)
   end

   return output_state
end

---Persist the cached output-directory state.
---@return boolean success
local function save_output_state()
   return save_json_state(M.output_state_path, load_output_state())
end

local root_state = nil

---Load and cache the source-to-root-file mappings.
---@return table
local function load_root_state()
   if root_state == nil then
      root_state = load_json_state(M.root_state_path)
   end

   return root_state
end

---Persist the cached source-to-root-file mappings.
---@return boolean success
local function save_root_state()
   return save_json_state(M.root_state_path, load_root_state())
end

---Build the default output directory for a project root.
---@param root string
---@return string
local function default_output_dir(root)
   local root_name = basename(root)
   if root_name == '' then
      root_name = 'contentdev'
   end

   return normalize_path(join(vim.fn.stdpath('cache'), 'contentdev-build', root_name .. '-' .. short_hash(root)))
end

---Return the output directory stored for a project root.
---@param root string
---@return string?
local function persisted_output_dir(root)
   local state = load_output_state()
   return state[normalize_path(root)]
end

---Collect the current and historical output directories without duplicates.
---@param root string
---@return string[]
local function persisted_output_dirs(root)
   local state = load_output_state()
   local dirs = {}
   local seen = {}

   ---Normalize and add an output directory unless it is invalid or duplicated.
   ---@param path unknown
   local function add(path)
      if type(path) ~= 'string' then
         return
      end

      path = normalize_path(path)
      if path == '' or seen[path] then
         return
      end

      seen[path] = true
      table.insert(dirs, path)
   end

   add(state[normalize_path(root)])
   for _, path in ipairs(state[output_dir_history_key] or {}) do
      add(path)
   end

   local other_dirs = {}
   for key, path in pairs(state) do
      if key ~= output_dir_history_key and type(path) == 'string' then
         table.insert(other_dirs, path)
      end
   end
   table.sort(other_dirs)
   for _, path in ipairs(other_dirs) do
      add(path)
   end

   return dirs
end

---Persist an output directory and move it to the front of the history.
---@param root string
---@param output_dir string
---@return boolean success
local function set_persisted_output_dir(root, output_dir)
   local normalized_root = normalize_path(root)
   local normalized_output_dir = normalize_path(output_dir)
   if normalized_root == '' or normalized_output_dir == '' then
      return false
   end

   local state = load_output_state()
   local history = {}
   local seen = {}
   ---Normalize and append a unique directory to the new history list.
   ---@param path unknown
   local function add_to_history(path)
      if type(path) ~= 'string' then
         return
      end

      path = normalize_path(path)
      if path == '' or seen[path] then
         return
      end

      seen[path] = true
      table.insert(history, path)
   end

   add_to_history(normalized_output_dir)
   for _, path in ipairs(state[output_dir_history_key] or {}) do
      add_to_history(path)
   end
   for key, path in pairs(state) do
      if key ~= output_dir_history_key then
         add_to_history(path)
      end
   end

   state[normalized_root] = normalized_output_dir
   state[output_dir_history_key] = history
   return save_output_state()
end

---Create the state key for a project root and source file pair.
---@param root string
---@param source string
---@return string
local function root_target_key(root, source)
   return normalize_path(root) .. '|' .. normalize_path(source)
end

---Return a persisted, still-readable root target for a source file.
---@param root string
---@param source string
---@return string?
local function persisted_root_target(root, source)
   local target = load_root_state()[root_target_key(root, source)]
   if target and file_readable(target) then
      return normalize_path(target)
   end

   return nil
end

---Validate and persist the root target selected for a source file.
---@param root string
---@param source string
---@param target string
---@return boolean success
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

---Resolve the configured output directory for a project root.
---Global and environment overrides take precedence over persisted state.
---@param root string
---@return string?
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

---Resolve an output directory, prompting and persisting one if necessary.
---@param root string
---@param callback fun(output_dir: string)
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
   },
   ---Validate, persist, and return the directory entered by the user.
   ---@param input? string
   function(input)
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

---Return the configured output directory for a ContentDev buffer.
---@param bufnr? integer Defaults to the current buffer.
---@return string?
function M.output_dir_for_buffer(bufnr)
   bufnr = bufnr or 0
   if not M.is_contentdev_buffer(bufnr) then
      return nil
   end

   local root = M.root_for_buffer(bufnr)
   return M.output_dir_for_root(root)
end

---Use the current working directory as output directory for the current root.
function M.set_output_dir_to_cwd()
   local bufnr = vim.api.nvim_get_current_buf()
   if not M.is_contentdev_buffer(bufnr) then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   local root = M.root_for_buffer(bufnr)
   local cwd = normalize_path(vim.fn.getcwd())
   if set_persisted_output_dir(root, cwd) then
      vim.notify('ContentDev output base directory set to current working directory for ' .. root .. ': ' .. cwd, vim.log.levels.INFO)
   end
end

---Set or interactively select the output directory for the current root.
---@param path? string Directory to persist; prompts when omitted or empty.
function M.set_output_dir_for_current_root(path)
   local bufnr = vim.api.nvim_get_current_buf()
   if not M.is_contentdev_buffer(bufnr) then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   local root = M.root_for_buffer(bufnr)
   ---Persist a selected directory and report success to the user.
   ---@param output_dir string
   local function persist(output_dir)
      if set_persisted_output_dir(root, output_dir) then
         vim.notify('ContentDev output base directory set for ' .. root .. ': ' .. normalize_path(output_dir), vim.log.levels.INFO)
      end
   end

   if path and strip(path) ~= '' then
      persist(path)
      return
   end

   ---Prompt the user to enter an output directory.
   ---@param default_dir? string
   local function prompt_for_output_dir(default_dir)
      vim.ui.input({
         prompt = 'ContentDev output base directory for ' .. root .. ': ',
         default = default_dir or M.output_dir_for_root(root) or default_output_dir(root),
         completion = 'dir',
      },
      ---Persist a non-empty directory entered by the user.
      ---@param input? string
      function(input)
         input = strip(input)
         if input ~= '' then
            persist(input)
         end
      end)
   end

   local previous_dirs = persisted_output_dirs(root)
   if #previous_dirs == 0 then
      prompt_for_output_dir()
      return
   end

   local current_dir = normalize_path(M.output_dir_for_root(root))
   local choices = {}
   for _, output_dir in ipairs(previous_dirs) do
      table.insert(choices, {
         path = output_dir,
         label = output_dir .. (output_dir == current_dir and ' (current)' or ''),
      })
   end
   table.insert(choices, {
      label = 'Choose another directory...',
      manual = true,
   })

   vim.ui.select(choices, {
      prompt = 'ContentDev output base directory for ' .. root .. ':',
      ---Render an output-directory selection item.
      ---@param item table
      ---@return string
      format_item = function(item)
         return item.label
      end,
   },
   ---Handle a directory-history selection or open the manual-entry prompt.
   ---@param choice? table
   function(choice)
      if not choice then
         return
      end

      if choice.manual then
         prompt_for_output_dir()
         return
      end

      prompt_for_output_dir(choice.path)
   end)
end

---Resolve the compiler executable for a language and project root.
---@param language table ContentDev language descriptor.
---@param root string
---@return string
local function compiler_for_language(language, root)
   if vim.env[language.env] and vim.env[language.env] ~= '' then
      return normalize_path(vim.env[language.env])
   end

   local exe = language.exe
   if (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) and not exe:match('%.exe$') then
      exe = exe .. '.exe'
   end

   local candidate = normalize_path(join(compiler_dir_for_root(root), exe))
   if file_readable(candidate) then
      return candidate
   end

   return exe
end

---Return a path's lowercase file extension without the dot.
---@param path string
---@return string
local function file_extension(path)
   return lower(vim.fn.fnamemodify(path, ':e'))
end

---Check whether a path is an include file for a language.
---@param path string
---@param language table ContentDev language descriptor.
---@return boolean
local function is_include_file(path, language)
   return language.include_exts[file_extension(path)] == true
end

---Check whether a path can be compiled as a root file for a language.
---@param path string
---@param language table ContentDev language descriptor.
---@return boolean
local function is_root_file(path, language)
   return language.root_exts[file_extension(path)] == true
end

---Resolve the enclosing DMSource directory for a project root.
---@param root string
---@return string
source_base_from_root = function(root)
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

---Extract the StP major version from a conventional repository path.
---@param root string
---@return string?
stp_major_from_root = function(root)
   local source_base = source_base_from_root(root)
   return source_base:match('/Repos/Content/StP/(%d+)/DMSource$')
end

---Resolve the Tools directory associated with a project root.
---@param root string
---@return string
tools_root_for_root = function(root)
   local major = stp_major_from_root(root)
   if major then
      return normalize_path(join(vim.fn.expand('~/Repos/Content/StP'), major, 'Tools'))
   end

   return normalize_path(M.tools_root)
end

---Resolve the compiler directory, preferring the root-specific Tools tree.
---@param root string
---@return string
compiler_dir_for_root = function(root)
   local candidate = tools_root_for_root(root)
   if candidate ~= '' and path_exists(candidate) then
      return candidate
   end

   return normalize_path(M.compiler_dir)
end

---Resolve the ContentDev language-server executable for a project root.
---@param root string
---@return string
lsp_path_for_root = function(root)
   local candidate = normalize_path(join(compiler_dir_for_root(root), 'contentdev-lsp'))
   if file_readable(candidate) then
      return candidate
   end

   return normalize_path(M.lsp_path)
end

---Find an include file's root target from generated dependency metadata.
---@param path string Include-file path.
---@param root string Project root.
---@param language table ContentDev language descriptor.
---@return string?
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

---Check whether an include directive refers to a target path.
---Matching is case-insensitive and compares only the final path component.
---@param include_name string
---@param target string
---@return boolean
local function include_target_matches(include_name, target)
   local normalized_include = include_name:gsub('\\', '/')
   return lower(basename(normalized_include)) == lower(basename(target))
end

---Check whether a path is a root source file for a language.
---@param path string
---@param language table ContentDev language descriptor.
---@return boolean
local function file_in_language_source(path, language)
   local ext = file_extension(path)
   if not language.root_exts[ext] then
      return false
   end

   return true
end

---Find root files that directly include the specified file.
---@param path string Included file path.
---@param root string Project root.
---@param language table ContentDev language descriptor.
---@return string[]
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

---Return a path relative to a root when it is contained by that root.
---@param path string
---@param root string
---@return string
local function relative_to_root(path, root)
   local normalized_path = normalize_path(path)
   local normalized_root = normalize_path(root)
   if normalized_path:sub(1, #normalized_root + 1) == normalized_root .. '/' then
      return normalized_path:sub(#normalized_root + 2)
   end

   return normalized_path
end

---Add a readable, unique root-file candidate to a list.
---@param candidates table[]
---@param seen table<string, boolean>
---@param root string
---@param path string
---@param label? string
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

---Discover possible root files for a source or include file.
---@param path string Source-file path.
---@param root string Project root.
---@param language table ContentDev language descriptor.
---@return table[] candidates
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

---Prompt the user to choose or manually enter a root file.
---@param root string Project root.
---@param source string Source-file path.
---@param language table ContentDev language descriptor.
---@param candidates table[] Root-file candidates; the selection entry is appended in place.
---@param callback fun(target: string?, error: string?)
local function choose_root_file(root, source, language, candidates, callback)
   local manual = {
      label = 'Choose another root file...',
      path = nil,
      manual = true,
   }

   table.insert(candidates, manual)
   vim.ui.select(candidates, {
      prompt = 'ContentDev root file for ' .. relative_to_root(source, root) .. ':',
      ---Render a root-file selection item.
      ---@param item table
      ---@return string
      format_item = function(item)
         return item.label
      end,
   },
   ---Persist a selected root candidate or prompt for a custom file.
   ---@param choice? table
   function(choice)
      if not choice then
         callback(nil, 'No root file selected.')
         return
      end

      if choice.manual then
         vim.ui.input({
            prompt = 'ContentDev root file: ',
            default = normalize_path(join(source_base_from_root(root), language.source_dirs[1] or '', basename(source))),
            completion = 'file',
         },
         ---Validate and persist a manually entered root-file path.
         ---@param input? string
         function(input)
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

---Decide whether root-file resolution requires an explicit user choice.
---@param path string Source-file path.
---@param language table ContentDev language descriptor.
---@param candidates table[]
---@return boolean
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

---Resolve the compiler target for a buffer, prompting when ambiguous.
---@param bufnr integer Neovim buffer number.
---@param language table ContentDev language descriptor.
---@param force_select boolean Whether to always show the root selection.
---@param callback fun(target: string?, error: string?)
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

---Infer the DMScript script type from a source path or extension.
---@param path string
---@return string?
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

---Return a source path relative to its DMSource directory.
---@param path string
---@param root string
---@return string
local function relative_to_source_base(path, root)
   local source_base = source_base_from_root(root)
   local normalized_path = normalize_path(path)
   if normalized_path:sub(1, #source_base + 1) == source_base .. '/' then
      return normalized_path:sub(#source_base + 2)
   end

   return basename(path)
end

---Return a path's parent directory, mapping `.` to an empty string.
---@param path string
---@return string
local function parent_dir_or_empty(path)
   local dir = dirname(path)
   if dir == '.' then
      return ''
   end

   return dir
end

---Compute the output directory for a language target.
---@param language table ContentDev language descriptor.
---@param target string Compiler target path.
---@param output_base_dir string Configured output base directory.
---@param root string Project root.
---@return string
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

   return normalize_path(table.concat(output_parts, '/'))
end

---Resolve the generated file extension for a language target.
---@param language table ContentDev language descriptor.
---@param target string Compiler target path.
---@return string?
local function language_output_ext(language, target)
   if language.dsl == 'dmscript' then
      local script_type = dmscript_type_for_path(target)
      return language.output_exts_by_script and language.output_exts_by_script[script_type]
   end

   return language.output_ext
end

---Compute the complete output-file path for a language target.
---@param language table ContentDev language descriptor.
---@param target string Compiler target path.
---@param output_base_dir string Configured output base directory.
---@param root string Project root.
---@return string
local function language_output_file(language, target, output_base_dir, root)
   local out_dir = language_output_dir(language, target, output_base_dir, root)
   local output_ext = language_output_ext(language, target)
   if output_ext == nil or output_ext == '' then
      return out_dir
   end

   local output_name = lower(vim.fn.fnamemodify(target, ':t:r')) .. '.' .. output_ext
   return normalize_path(join(out_dir, output_name))
end

---Return the shared DDF name-table path below an output directory.
---@param output_base_dir string
---@return string
local function name_table_file(output_base_dir)
   return normalize_path(join(output_base_dir, 'ddf', 'nametbl.ndx'))
end

---Append include, name-table, and Help-specific options to compiler arguments.
---@param args string[] Argument list modified in place.
---@param language table ContentDev language descriptor.
---@param target string Compiler target path.
---@param output_base_dir string Configured output base directory.
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

---Build the compiler command line and create its output directories.
---@param language table ContentDev language descriptor.
---@param target string Compiler target path.
---@param output_base_dir string Configured output base directory.
---@param root string Project root.
---@return string[]? args
---@return string? error
---@return string? output_file
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

   local args = { compiler_for_language(language, root) }
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
   })

   if M.compiler_meta_dir_flag and M.compiler_meta_dir_flag ~= '' then
      table.insert(args, M.compiler_meta_dir_flag .. meta_dir)
   end

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

---Split compiler output into non-empty lines.
---@param output? string
---@return string[]
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

---Convert compiler output into Neovim quickfix entries.
---@param output? string
---@param fallback_file string File assigned to unstructured output lines.
---@return table[]
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

---Publish a completed build to the quickfix list and notify the user.
---@param language table ContentDev language descriptor.
---@param target string Compiler target path.
---@param output_dir string Generated output-file path.
---@param result table Completed `vim.system` result.
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

---Save all buffers and asynchronously compile the current ContentDev target.
---Any running ContentDev build is terminated before the new one is resolved.
function M.build_current_buffer()
   local bufnr = vim.api.nvim_get_current_buf()
   local language = build_languages[vim.bo[bufnr].filetype]
   if not language then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   if current_build and current_build.kill then
      ---Terminate the previous process while insulating the new build from kill errors.
      pcall(function()
         current_build:kill(15)
      end)
      current_build = nil
   end

   local root = M.root_for_buffer(bufnr)
   ---Continue the build after asynchronous root-target resolution.
   ---@param target? string
   ---@param target_error? string
   resolve_target_for_buffer(bufnr, language, false, function(target, target_error)
      if not target then
         vim.notify('ContentDev build cancelled: ' .. target_error, vim.log.levels.ERROR)
         return
      end

      ---Continue the build after asynchronous output-directory resolution.
      ---@param output_dir string
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

         ---Save all buffers while converting command errors into build errors.
         local saved, save_error = pcall(function()
            vim.cmd('wall')
         end)
         if not saved then
            vim.notify('ContentDev build cancelled: could not save all buffers: ' .. tostring(save_error), vim.log.levels.ERROR)
            return
         end

         vim.cmd('cclose')
         vim.notify('ContentDev ' .. language.name .. ' build started: ' .. target, vim.log.levels.INFO)
         ---Transfer the asynchronous compiler result back to Neovim's main loop.
         ---@param result table
         current_build = vim.system(args, { text = true }, function(result)
            ---Update editor state from the scheduled main-loop callback.
            vim.schedule(function()
               finish_build(language, target, assert(out_dir), result)
            end)
         end)
      end)
   end)
end

---Interactively select and persist a root file for the current buffer.
function M.select_root_for_current_buffer()
   local bufnr = vim.api.nvim_get_current_buf()
   local language = build_languages[vim.bo[bufnr].filetype]
   if not language then
      vim.notify('Current buffer is not a ContentDev buffer.', vim.log.levels.WARN)
      return
   end

   ---Report the result of the asynchronous root-file selection.
   ---@param target? string
   ---@param target_error? string
   resolve_target_for_buffer(bufnr, language, true, function(target, target_error)
      if target then
         vim.notify('ContentDev root file set: ' .. target, vim.log.levels.INFO)
      else
         vim.notify('ContentDev root file not changed: ' .. target_error, vim.log.levels.WARN)
      end
   end)
end

---Configure diagnostics when the ContentDev LSP attaches to a buffer.
---@param client table LSP client instance.
---@param bufnr integer Neovim buffer number.
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

---Build the Neovim LSP configuration for the current ContentDev root.
---@return table
function M.lsp_config()
   local root = M.root_for_buffer(0)
   return {
      name = 'contentdev_lsp',
      cmd = { lsp_path_for_root(root) },
      filetypes = M.filetypes,
      root_dir = contentdev_root,
      init_options = {
         compilerDir = compiler_dir_for_root(root),
         liveSyntaxDiagnostics = true,
         compilerDiagnosticsOnSave = true,
      },
      on_attach = M.configure_diagnostics,
      single_file_support = true,
   }
end

---Start the ContentDev language server for a buffer.
---@param bufnr integer Neovim buffer number.
function M.start_lsp(bufnr)
   local config = M.lsp_config()
   config.root_dir = resolve_root(bufnr)
   vim.lsp.start(config, { bufnr = bufnr })
end

local tree_sitter_group = vim.api.nvim_create_augroup('contentdev_treesitter', { clear = true })
local lsp_group = vim.api.nvim_create_augroup('contentdev_lsp', { clear = true })

local commentstrings = {
   contentdev_ddf      = '// %s',
   contentdev_yaddl    = '// %s',
   contentdev_help     = '<!-- %s -->',
   contentdev_dmscript = '// %s',
}

---Enable Tree-sitter, folding, and comment settings for a ContentDev buffer.
---@param bufnr integer Neovim buffer number.
local function setup_treesitter_for_buf(bufnr)
   M.ensure_runtimepath()
   pcall(vim.treesitter.start, bufnr)
   vim.wo.foldmethod = 'expr'
   vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
   local cs = commentstrings[vim.bo[bufnr].filetype]
   if cs then
      vim.bo[bufnr].commentstring = cs
   end
end

vim.api.nvim_create_autocmd('FileType', {
   group = tree_sitter_group,
   pattern = M.filetypes,
   ---Initialize Tree-sitter whenever a ContentDev filetype is assigned.
   ---@param args table Autocommand event data containing the buffer number.
   callback = function(args)
      setup_treesitter_for_buf(args.buf)
   end,
})

vim.api.nvim_create_autocmd('BufEnter', {
   group = tree_sitter_group,
   ---Restore the language-specific comment string when entering a buffer.
   ---@param args table Autocommand event data containing the buffer number.
   callback = function(args)
      if M.is_contentdev_buffer(args.buf) then
         local cs = commentstrings[vim.bo[args.buf].filetype]
         if cs and vim.bo[args.buf].commentstring ~= cs then
            vim.bo[args.buf].commentstring = cs
         end
      end
   end,
})

vim.api.nvim_create_autocmd('FileType', {
   group = lsp_group,
   pattern = M.filetypes,
   ---Start the ContentDev LSP when a supported filetype is assigned.
   ---@param args table Autocommand event data containing the buffer number.
   callback = function(args)
      M.start_lsp(args.buf)
   end,
})

---Copy Tree-sitter query files from a grammar into the generated runtime.
---@param language table ContentDev language descriptor.
---@param source_dir string Grammar source directory.
---@return boolean success
---@return string? error
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

---Build and install every configured ContentDev Tree-sitter parser and query set.
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

---Install ContentDev Tree-sitter assets from the user command.
vim.api.nvim_create_user_command('ContentDevInstallTreesitter', function()
   M.install_treesitter()
end, { desc = 'Build and install ContentDev Tree-sitter parsers' })

---Compile the current ContentDev buffer from the user command.
vim.api.nvim_create_user_command('ContentDevBuild', function()
   M.build_current_buffer()
end, { desc = 'Build the current ContentDev buffer' })

---Set the current root's output directory from user-command arguments.
---@param opts table User-command invocation data.
vim.api.nvim_create_user_command('ContentDevSetOutputDir', function(opts)
   M.set_output_dir_for_current_root(opts.args)
end, {
   nargs = '?',
   complete = 'dir',
   desc = 'Set the ContentDev output base directory for the current ContentDev root',
})

---Open the root-file selector from the user command.
vim.api.nvim_create_user_command('ContentDevSelectRootFile', function()
   M.select_root_for_current_buffer()
end, { desc = 'Select the ContentDev root file for the current source file' })

---Print the resolved ContentDev paths and selections for the current buffer.
vim.api.nvim_create_user_command('ContentDevInfo', function()
   local root = M.root_for_buffer(0)
   local output_dir = M.output_dir_for_root(root) or '(not set)'
   local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
   local root_file = persisted_root_target(root, current_file) or '(not set)'
   print(table.concat({
      'ContentDev LSP: ' .. lsp_path_for_root(root),
      'ContentDev compiler dir: ' .. compiler_dir_for_root(root),
      'ContentDev output base dir: ' .. output_dir,
      'ContentDev selected root file: ' .. root_file,
      'ContentDev tools root: ' .. tools_root_for_root(root),
      'ContentDev root: ' .. root,
      'ContentDev Tree-sitter runtime: ' .. M.runtime_dir,
   }, '\n'))
end, { desc = 'Show ContentDev Neovim paths' })

---Register and enable the ContentDev LSP on Neovim versions supporting the API.
local function enable_lsp()
   if vim.lsp and vim.lsp.config and vim.lsp.enable then
      ---Register the configuration without failing module initialization.
      pcall(function() vim.lsp.config('contentdev_lsp', M.lsp_config()) end)
      ---Enable the configuration without failing module initialization.
      pcall(function() vim.lsp.enable('contentdev_lsp') end)
   end
end

enable_lsp()

vim.api.nvim_create_autocmd('VimEnter', {
   group = lsp_group,
   callback = enable_lsp,
})

return M
