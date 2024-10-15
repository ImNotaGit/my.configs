return {

  -- language servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      local lspconfig = require("lspconfig")
      local nvlsp = require("nvchad.configs.lspconfig")
      -- in the current NvChad version (2.5), these can be installed by manually calling :MasonInstallAll; the mappings to Mason package names were found in lua/nvchad/mason/names.lua under the NvChad/ui repo
      -- before installing, need to ensure gcc and npm (nodejs) and other language-specific dependencies on $PATH
      local servers = {
        "awk_ls",
        "bashls",
        "cssls",
        "dockerls",
        "groovyls",
        "html",
        "java_language_server",
        "jsonls",
        "julials",
        "lemminx",
        "perlnavigator",
        "pylsp",
        "r_language_server",
        "vimls",
        "yamlls",
      }
      -- lsps with default config
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = nvlsp.on_attach,
          on_init = nvlsp.on_init,
          capabilities = nvlsp.capabilities,
        }
      end
      -- configuring single server, example: typescript
      -- lspconfig.ts_ls.setup {
      --   on_attach = nvlsp.on_attach,
      --   on_init = nvlsp.on_init,
      --   capabilities = nvlsp.capabilities,
      -- }
    end,
  },

}
