--[===[
Sonarqube
sonarqube integrates with the sonarlint-language-server to deliver real-time
static analysis and code actions directly in neovim.

URL: https://gitlab.com/schrieveslaach/sonarlint.nvim
--]===]

local analyzers_path = vim.fn.stdpath "data" .. "/mason/packages/sonarlint-language-server/extension/analyzers/"

local sonarlint_ft = {
   "c",
   "cpp",
   "css",
   "docker",
   "go",
   "html",
   "java",
   "javascript",
   "javascriptreact",
   "php",
   "python",
   "typescript",
   "typescriptreact",
   "xml",
   "yaml.docker-compose",
}

return {
   "https://gitlab.com/schrieveslaach/sonarlint.nvim",
   enabled = true,
   ft = sonarlint_ft,
   opts = {
      connected = {
         get_credentials = function(_, _)
            return vim.fn.getenv("SONAR_TOKEN")
         end,
      },
      server = {
         cmd = {
            "sonarlint-language-server",
            "-stdio",
            "-analyzers",
            analyzers_path .. "sonargo.jar",
            analyzers_path .. "sonarcfamily.jar",
            analyzers_path .. "sonarhtml.jar",
            analyzers_path .. "sonariac.jar",
            analyzers_path .. "sonarjava.jar",
            analyzers_path .. "sonarjavasymbolicexecution.jar",
            analyzers_path .. "sonarjs.jar",
            analyzers_path .. "sonarphp.jar",
            analyzers_path .. "sonarpython.jar",
            analyzers_path .. "sonarxml.jar",
         },
         settings = {
            sonarlint = {
               pathToCompileCommands = analyzers_path .. "compile_commands.json",
               connectedMode = {
                  connections = {
                     sonarqube = {
                        {
                           connectionId = "https-sonarqube-cloud-dev-wolterskluwer-eu-",
                           -- this is the url that will go into get_credentials
                           serverUrl = "https://sonarqube.cloud-dev.wolterskluwer.eu/",
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
               ["~/Repos/SSE/Dev/"] = "TAA.DE.Steuertipps.SSE",
               -- … further mappings …
            }

            config.settings.sonarlint.connectedMode.project = {
               connectionId = "https-sonarqube-cloud-dev-wolterskluwer-eu-",
               projectKey = project_root_and_ids[params.rootPath],
            }
         end,
      },
      filetypes = sonarlint_ft,
   },
}
