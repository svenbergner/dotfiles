--[===[
Sonarqube
https://gitlab.com/schrieveslaach/sonarlint.nvim

New cfamily plugins:
https://binaries.sonarsource.com/?prefix=CommercialDistribution/sonar-cfamily-plugin/

Current version:
~/.local/share/nvim/mason/packages/sonarlint-language-server/extension/package.json

```bash
jq '.. | objects | select(.artifactId? == "sonar-cfamily-plugin") | .version' \
  ~/.local/share/nvim/mason/packages/sonarlint-language-server/extension/package.json
```

Integrates with the sonarlint-language-server to deliver real-time
static analysis and code actions directly in neovim
--]===]

local extension_path = vim.fn.stdpath('data') .. '/mason/packages/sonarlint-language-server/extension'
local analyzers_path = extension_path .. '/analyzers/'

local missing_token_notified = false

local sonarlint_ft = {
   'c',
   'cpp',
   'css',
   'dockerfile',
   'go',
   'html',
   'java',
   'javascript',
   'javascriptreact',
   'php',
   'python',
   'typescript',
   'typescriptreact',
   'xml',
   'yaml',
}

return {
   'https://gitlab.com/schrieveslaach/sonarlint.nvim',
   enabled = true,
   ft = sonarlint_ft,
   dependencies = { 'lewis6991/gitsigns.nvim' },
   opts = {
      connected = {
         get_credentials = function(_, _)
            local token = vim.env.SONAR_TOKEN
            if token and token ~= '' then
               return token
            end

            if not missing_token_notified then
               missing_token_notified = true
               vim.schedule(function()
                  vim.notify(
                     'SONAR_TOKEN is missing or empty; SonarLint is starting in local mode.',
                     vim.log.levels.WARN,
                     { title = 'SonarLint' }
                  )
               end)
            end

            return nil
         end,
      },
      server = {
         cmd = {
            'sonarlint-language-server',
            '-stdio',
            '-analyzers',
            analyzers_path .. 'sonargo.jar', -- Go
            analyzers_path .. 'sonarcfamily.jar', -- C, C++
            analyzers_path .. 'sonarhtml.jar', -- HTML
            analyzers_path .. 'sonariac.jar', -- Infrastructure-as-Code
            analyzers_path .. 'sonarjs.jar', -- JavaScript, TypeScript
            analyzers_path .. 'sonarpython.jar', -- Python
            analyzers_path .. 'sonarxml.jar', -- XML, XSLT
            analyzers_path .. 'sonarjava.jar', -- Java
            analyzers_path .. 'sonarjavasymbolicexecution.jar', -- Java symbolic execution
            analyzers_path .. 'sonarphp.jar', -- PHP
         },
         settings = {
            sonarlint = {
               rules = {
                  -- Disable some rules that are not useful in our context
                  -- or that produce too many false positives.
                  -- See rule descriptions at
                  -- https://sonarsource.github.io/rspec/#/rspec/SXXXX
                  -- or search for a rule by name
                  -- https://sonarsource.github.io/rspec/#/rspec/?lang=cfamily&query=replace+new
                  ['cpp:S125'] = { level = 'off' }, -- Sections of code should not be commented out
                  ['cpp:S134'] = { level = 'off' }, -- Control flow statements "IF", "CASE", "DO", "LOOP", "SELECT", "WHILE" and "PROVIDE" should not be nested too deeply
                  ['cpp:S995'] = { level = 'off' }, -- Change to pointer-to-const
                  ['cpp:S1066'] = { level = 'off' }, -- Mergeable "if" statements should be combined
                  ['cpp:S5025'] = { level = 'off' }, -- Memory should not be managed manually
                  ['cpp:S5350'] = { level = 'off' }, -- Pointer and reference local variables should be "const" if the corresponding object is not modified
                  ['cpp:S5566'] = { level = 'off' }, -- STL algorithms and range-based for loops should be preferred to traditional for loops
                  ['cpp:S6004'] = { level = 'off' }, -- "if" and "switch" initializer should be used to reduce scope of variables
                  ['cpp:S6045'] = { level = 'off' }, -- Transparent function objects should be used with associative "std::string" containers
                  ['cpp:S6177'] = { level = 'off' }, -- "using enum" should be used in scopes with high concentration of "enum" constants
                  ['cpp:S7034'] = { level = 'off' }, -- cxx23 contains
               },
               connectedMode = {
                  connections = {
                     sonarqube = {
                        {
                           connectionId = 'https-sonarqube-cloud-dev-wolterskluwer-eu-',
                           -- this is the url that will go into get_credentials
                           serverUrl = 'https://sonarqube.cloud-dev.wolterskluwer.eu/',
                           disableNotifications = false,
                        },
                     },
                  },
               },
            },
         },

         before_init = function(params, config)
            local project_root = vim.fs.normalize(vim.fn.expand('~/Repos/SSE/Dev'))
            local projects = {
               [project_root] = {
                  project_key = 'TAA.DE.Steuertipps.SSE',
                  compile_commands = project_root .. '/compile_commands.json',
               },
               -- … further mappings …
            }

            local root_path = params.rootPath
            if not root_path and params.rootUri then
               root_path = vim.uri_to_fname(params.rootUri)
            end

            local normalized_root = root_path and vim.fs.normalize(root_path)
            local project = normalized_root and projects[normalized_root]
            if not project then
               vim.schedule(function()
                  vim.notify(
                     'No SonarQube project mapping configured for root: ' .. (normalized_root or '<unknown>'),
                     vim.log.levels.WARN,
                     { title = 'SonarLint' }
                  )
               end)
               return
            end

            config.settings.sonarlint.pathToCompileCommands = project.compile_commands
            config.settings.sonarlint.connectedMode.project = {
               connectionId = 'https-sonarqube-cloud-dev-wolterskluwer-eu-',
               projectKey = project.project_key,
            }
         end,
      },
      filetypes = sonarlint_ft,
   },
}
