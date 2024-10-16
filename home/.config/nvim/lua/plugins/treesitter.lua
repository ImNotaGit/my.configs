return {

  -- treesitter syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      pcall(function()
        dofile(vim.g.base46_cache .. "syntax")
        dofile(vim.g.base46_cache .. "treesitter")
      end)
      return {
        ensure_installed = {
          "awk",
          "bash",
          "c",
          "cmake",
          "cpp",
          "css",
          "csv",
          "diff",
          "dockerfile",
          "doxygen",
          "fortran",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "groovy",
          "html",
          "java",
          "javascript",
          "json",
          "json5",
          "julia",
          -- "latex", -- requires tree-sitter cli, which I had trouble installing
          "lua",
          "luadoc",
          "make",
          "markdown",
          "markdown_inline",
          "matlab",
          "perl",
          "printf",
          "python",
          "r",
          "regex",
          "ruby",
          "rust",
          "snakemake",
          "sql",
          "toml",
          "tsv",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        highlight = {
          enable = true,
          -- disable = { "c", "rust" },
          use_languagetree = true,
        },
        indent = {
          enable = true,
        },
      }
    end,
    -- may need to manually call :TSInstall awk to initiate the install of all parsers (awk is arbitrary)
    config = function(_, opts)
      -- without this line below, treesitter somehow would not use the proper gcc in $PATH, which will lead to errors
      require("nvim-treesitter.install").compilers = { "gcc" }
      -- parser-specific options
      local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_configs.markdown = {
      --   filetype = { "markdown", "rmd" } -- not sure if I can pass an array
      -- }
      require("nvim-treesitter.configs").setup(opts)
      -- use the markdown parser for rmd; I did not have to specify this before, but somehow now in rmd files treesitter is not enabled
      vim.treesitter.language.register("markdown", { "markdown", "rmd" })
      -- set conceal level to 0 to avoid unexpected code display issues
      vim.g.conceallevel = 0
    end,
  },

}
