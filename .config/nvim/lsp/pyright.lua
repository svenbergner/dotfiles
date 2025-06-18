return {
   cmd = {'pyright-langserver', '--stdio'},
   filetypes = { "python" },
   settings = {
      python = {
         analysis = {
            typeCheckingMode = "strict",
            maxLineLength = 120,
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
            -- stubPath = "/usr/lib/python3.9/site-packages",
         }
      }
   },
}
