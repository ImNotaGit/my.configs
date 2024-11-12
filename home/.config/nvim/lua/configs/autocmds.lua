require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- my filetype definitions
autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"Snakefile", "*.smk"},
  command = "set filetype=snakemake",
})
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.vcf",
  command = "set filetype=vcf",
})
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.maf",
  command = "set filetype=maf",
})
autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.bed",
  command = "set filetype=bed",
})

autocmd({"BufNew", "BufNewFile", "BufRead"}, {
  pattern = "*",
  callback = function()
    -- do not automatically insert comment leader the next line of a current comment
    vim.cmd("setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
    -- highlight tabs and trailing whitespaces with the SpecialKey highlight group
    vim.cmd([[match SpecialKey /\t\|\s\+$/]])
  end,
})

-- after exiting insert mode, place cursor to the right rather than to the left (default)
autocmd("InsertLeave", {
  pattern = "*",
  command = ":normal! `^",
})

-- put in insert mode when entering terminal window
autocmd({"BufWinEnter", "WinEnter"}, {
  pattern = "term://*",
  command = "startinsert",
})

autocmd("FileType", {
  pattern = {"text", "markdown"},
  command = "setlocal wrap",
})

-- rainbow_csv messes up with tsv and csv `filetype` value so I use BufNewFile and BufRead
autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.txt", "*.tsv", "*.csv", "*.bed", "*.vcf", "*.maf"},
  command = "setlocal ts=12 sts=12 sw=12 noexpandtab",
})

autocmd("FileType", {
  pattern = {"r", "rmd"},
  command = "setlocal ts=2 sts=2 sw=2 expandtab",
})

autocmd("FileType", {
  pattern = "sh",
  command = "setlocal ts=4 sts=4 sw=4 expandtab",
})

autocmd("FileType", {
  pattern = "snakemake",
  command = "setlocal ts=4 sts=4 sw=4 expandtab",
})

local template_path = vim.fn.stdpath "config" .. "/templates/"

autocmd("BufNewFile", {
  pattern = {"*.sh", "*.bash"},
  command = "0r " .. template_path .. "template.bash",
})

autocmd("BufNewFile", {
  pattern = {"*.R", "*.r"},
  command = "0r " .. template_path .. "template.R",
})

autocmd("BufNewFile", {
  pattern = {"*.Rmd", "*.rmd"},
  command = "0r " .. template_path .. "template.Rmd",
})
