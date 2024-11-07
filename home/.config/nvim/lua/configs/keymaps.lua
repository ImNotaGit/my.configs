require "nvchad.mappings"

local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

-- note that <C-i> and <Tab>, <C-[> and <Esc>, <C-m> and <CR> are internally the same and cannot be distinguished, so avoid mapping to these combo keys.
-- <Ctrl> + non-alphabetic cannot be mapped (although some can be mapped with <Alt>); <A-i> also cannot be mapped in my terminal for some reason

-- a reminder of commonly used mappings set by NvChad
-- i, C-j/k/h/l: move around
-- i, C-b/e: go to beginning/end of line
-- n, C-j/k/h/l: go to window above/below/left/right

-- various insert mode mappings; note that <C-o> is temporary exit insert mode
map("i", "jk", "<Esc>", { desc = "exit insert mode" })
map("i", "<C-a>", "<C-o>^", { desc = "go to beginning of line" })
map("i", "<C-y>", "<C-o>b", { desc = "go to start of previous word" })
map("i", "<C-u>", "<C-o>w", { desc = "go to start of next word" })
map("i", "<C-f>", "<C-o>f", { desc = "go to next occurence of character" })
map("i", "<C-d>", "<C-o>F", { desc = "go to previous occurence of character" })
map("i", ";;", "<C-o>;", { desc = "repeat f/F" })
map("i", "%$", "<C-o>%<Right>", { desc = "go to left matching bracket" })

-- NvChad map <A-h> to toggle horizontal terminal, I change this to <C-t> and use <A-h> instead for moving character to left
map({ "n", "t" }, "<A-h>", "")
map("n", "<A-h>", ":MoveHChar(-1)<CR>", { noremap = true, silent = true } )
map({ "n", "t" }, "<C-t>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map("n", "<Esc>", ":noh<CR>", { desc = "clear highlights", noremap = true }) -- this mapping is NvChad default but I need to specify noremap=true
map("n", "<CR>", "{lV}$h", { desc = "select paragraph or block" }) -- I need line-wise select to make pasting easier, $h to avoid selecting ending empty line while also accounting for end-of-file no empty line case
map("v", "<CR>", "j}$h", { desc = "further select next paragraph or block" })
map("v", "u", "") -- disable change to lower case in visual mode
map("n", "<C-p>", "<C-w>p", { desc = "go to previous window" })
map("v", "x", "di", { desc = "selete select then enter insert mode" })

-- in terminal window insert mode, jk to exit insert, <C-k>/<C-p> to go up/to previous window (I usually have the terminal in the bottom)
-- for some reason a simple map w/o autocmd, or mapping to e.g. "<Esc><C-w>k" does not work...
autocmd({"BufWinEnter", "WinEnter"}, {
  pattern = "term://*",
  callback = function()
    map("t", "jk", function()
      vim.cmd("stopinsert")
    end, { buffer = 0, noremap = true, desc = "exit terminal insert mode" })
    map("t", "<C-k>", function()
      vim.cmd("stopinsert")
      vim.cmd("wincmd k")
    end, { buffer = 0, noremap = true, desc = "go to window above" })
    map("t", "<C-p>", function()
      vim.cmd("stopinsert")
      vim.cmd("wincmd p")
    end, { buffer = 0, noremap = true, desc = "go to previous window" })
  end,
})

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
    vim.api.nvim_buf_set_keymap(0, "i", "_ ", " <- ", { noremap =true })
  end,
})
