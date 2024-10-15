require "nvchad.mappings"

local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

map("i", "jk", "<Esc>", { desc = "exit insert mode" })
map("n", "<Esc>", ":noh<CR>", { desc = "clear highlights", noremap = true }) -- this mapping is NvChad default but I need to specify noremap=true
map("n", "<CR>", "{lv}", { desc = "select paragraph or block" })
map("n", "<M-j>", "ddp", { desc = "move line down 1 line" })
map("n", "<M-k>", "ddkP", { desc = "move line up 1 line" })
map("v", "<CR>", "}", { desc = "further select next paragraph or block" })
map("v", "<M-j>", "dp", { desc = "move line down 1 line" })
map("v", "<M-k>", "dkP", { desc = "move line up 1 line" })
map("v", "u", "", { desc = "disable change to lower case in visual mode" })

-- in Rmd, insert new code chunk or break current code chunk into two; the mapping behavior may change with different editor settings or plugins installed (?), so it could be non-robust...
autocmd("FileType", {
  pattern = "rmd",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>`", "o```{r}<CR><CR>```<Up>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "i", "<LocalLeader>`", "```{r}<CR><CR>```<Up>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>1", "o```<CR><CR>```{r}<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "i", "<LocalLeader>1", "```<CR><CR>```{r}<CR>", { noremap = true })
  end,
})

-- R and Rmd
autocmd("FileType", {
  pattern = {"r", "rmd"},
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "i", ".. ", " %>% ", { noremap =true })
    vim.api.nvim_buf_set_keymap(0, "i", "..<CR>", " %>%<CR>", { noremap =true })
    vim.api.nvim_buf_set_keymap(0, "i", "--", " <- ", { noremap =true })
  end,
})
