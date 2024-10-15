return {

  -- treesitter syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
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
        "make",
        "markdown",
        "markdown_inline",
        "matlab",
        "perl",
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
    },
    -- may need to manually call :TSInstall awk to initiate the install of all parsers (awk is arbitrary)
    config = function(_, opts)
      -- without this line below, treesitter somehow would not use the proper gcc in $PATH, which will lead to errors
      require("nvim-treesitter.install").compilers = { "gcc" }
      require("nvim-treesitter.configs").setup(opts)
      vim.g.conceallevel = 0
    end,
  },

}
