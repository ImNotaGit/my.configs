return {

  -- send code to command line interpreter in terminal for several languages
  {
    "jalvesaq/vimcmdline",
    lazy = false,
    config = function()
      vim.g.cmdline_term_height = 18
      vim.g.cmdline_follow_colorscheme = 1
      vim.g.cmdline_map_send = '<LocalLeader>\\'
      vim.g.cmdline_map_send_and_stay = '<LocalLeader>\\\\'
      vim.g.cmdline_app = {
        python = "ipython",
      }
    end,
  },

  -- R
  {
    "jalvesaq/Nvim-R",
    ft = {"r", "rmd"},
    config = function()
      --vim.g.R_path = "/SFS/product/R/4.2.1/centos7_x86_64/bin"
      vim.g.R_app = "radian"
      vim.g.R_cmd = "R"
      vim.g.R_args = {}
      vim.g.R_bracketed_paste = 1
      vim.g.R_auto_start = 1
      vim.g.Rout_more_colors = 0
      vim.g.rout_follow_colorscheme = 0
      vim.g.R_hl_term = 0
      vim.g.R_assign = 0
      vim.g.R_insert_mode_cmds = 1
      vim.g.R_rconsole_height = 18
      vim.g.R_rconsole_width = 0
    end,
  },

  -- autocompletion for Nvim-R
  {
    "jalvesaq/cmp-nvim-r",
    ft = {"r", "rmd"},
    config = function()
      require("cmp_nvim_r").setup({
        filetypes = {'r', 'rmd', 'quarto', 'rnoweb', 'rhelp'},
        doc_width = 58
      })
    end,
  },

  -- Nextflow (.nf) file syntax highlighting
  {
    "LukeGoodsell/nextflow-vim",
    ft = { "nextflow" },
  },

  -- color csv/tsv files: I modifed the original mechatroner/rainbow_csv to make it work for me
  {
    "ImNotaGit/rainbow_csv",
    ft = {"csv", "tsv", "text", "bed", "vcf", "maf"},
    keys = {"<M-t>"},
    config = function()
      vim.keymap.set("n", "<M-t>", [[:set ts=12 | let g:rainbow_comment_prefix="#" | RainbowMyInitTsv<CR>]], {noremap=true})
    end,
  },

}
