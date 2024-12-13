-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup(
  {
    -- load NvChad
    {
      "NvChad/NvChad",
      lazy = false,
      branch = "v2.5",
      import = "nvchad.plugins",
    },
    { import = "plugins" },
  },
  -- below are options for lazy.nvim
  {
    defaults = { lazy = true },
    install = { colorscheme = { "nvchad" } },
    ui = {
      icons = {
        ft = "",
        lazy = "󰂠 ",
        loaded = "",
        not_loaded = "",
      },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "tohtml",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "tar",
          "tarPlugin",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
          "ftplugin",
        },
      },
    },
  }
)

-- load NvChad themes
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- options
require "configs.options"

-- usercmds
require "configs.usercmds"

-- autocmds
require "configs.autocmds"

-- keymaps
vim.schedule(function()
  require "configs.keymaps"
end)
