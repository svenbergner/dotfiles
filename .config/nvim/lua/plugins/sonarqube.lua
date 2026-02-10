--[===[
Sonarqube
https://gitlab.com/schrieveslaach/sonarlint.nvim

Integrates with the sonarlint-language-server to deliver real-time
static analysis and code actions directly in neovim
--]===]

local analyzers_path = vim.fn.stdpath('data') .. '/mason/packages/sonarlint-language-server/extension/analyzers/'

local sonarlint_ft = {
   'c',
   'cpp',
   'css',
   'docker',
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
   'yaml.docker-compose',
}

return {
   'https://gitlab.com/schrieveslaach/sonarlint.nvim',
   enabled = true,
   ft = sonarlint_ft,
   opts = {
      connected = {
         get_credentials = function(_, _)
            return vim.fn.getenv('SONAR_TOKEN')
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
            -- analyzers_path .. "sonarjava.jar",
            -- analyzers_path .. "sonarjavasymbolicexecution.jar",
            -- analyzers_path .. "sonarphp.jar",
         },
         settings = {
            sonarlint = {
               pathToCompileCommands = analyzers_path .. 'compile_commands.json',
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
                  ['cpp:S3471'] = { level = 'off' }, -- "override" or "final" should be used instead of "virtual"
                  ['cpp:S3576'] = { level = 'off' }, -- "final" classes should not have "virtual" functions
                  ['cpp:S5025'] = { level = 'off' }, -- Memory should not be managed manually
                  ['cpp:S5350'] = { level = 'off' }, -- Pointer and reference local variables should be "const" if the corresponding object is not modified
                  ['cpp:S5566'] = { level = 'off' }, -- STL algorithms and range-based for loops should be preferred to traditional for loops
                  ['cpp:S6004'] = { level = 'off' }, -- "if" and "switch" initializer should be used to reduce scope of variables
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
            -- Your personal configuration needs to provide a mapping of root
            -- folders and project keys
            --
            -- In the future a integration with
            -- https://github.com/folke/neoconf.nvim or some similar
            -- plugin, might be worthwhile.
            local project_root_and_ids = {
               ['~/Repos/SSE/Dev/'] = 'TAA.DE.Steuertipps.SSE',
               -- … further mappings …
            }

            config.settings.sonarlint.connectedMode.project = {
               connectionId = 'https-sonarqube-cloud-dev-wolterskluwer-eu-',
               projectKey = project_root_and_ids[params.rootPath],
            }
         end,
      },
      filetypes = sonarlint_ft,
   },
}
