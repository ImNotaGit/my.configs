require "nvchad.options"

local opt = vim.opt
local o = vim.o
local config_path = vim.fn.stdpath "config" .. "/"

-- backup files
o.backupdir = "~/.nvim/backup//"
o.backup = true
-- vimviews
o.viewdir = "~/.nvim/views//"
-- swap files
o.directory = "~/.nvim/swap//"
-- viminfo stores the the state of your previous editing session
o.viminfo = vim.o.viminfo .. ",n~/.nvim/viminfo"
-- undofile - This allows you to use undos after exiting and restarting
o.undodir = "~/.nvim/undo//"
o.undofile = true

o.cursorlineopt ="both"
o.cursorcolumn = true
o.autochdir = true
o.wrap = false
o.textwidth = 0
o.clipboard = "unnamed"
o.mouse = "a"
o.virtualedit = "onemore"
--o.startofline = "off"
o.startofline = false
o.list = true
--o.listchars="tab:›\ ,trail:•"
--o.listchars=[[tab:›\ ,trail:•]]
o.listchars="tab:› ,trail:•"

-- custom vscode-format snippets for luasnip
vim.g.vscode_snippets_path = config_path .. "snippets"
