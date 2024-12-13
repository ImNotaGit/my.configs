local usercmd = vim.api.nvim_create_user_command

-- plot selected lines in R
local PltSel = function()
  -- open png device
  local script = {
    'if (exists(".w") && exists(".h")) {',
    '  png(sprintf(".Rplot%s.png", system("date +%m%d_%H%M%S", intern=TRUE)), width=.w, height=.h)',
    '} else {',
    '  png(sprintf(".Rplot%s.png", system("date +%m%d_%H%M%S", intern=TRUE)))',
    '}',
  }
  -- selected lines or current line
  local lines = vim.fn.getline(vim.fn.line("v"), vim.fn.line("."))
  table.insert(lines, "dev.off()")
  for _,line in ipairs(lines) do
    table.insert(script, line)
  end
  -- write to temp file, source it, then remove it
  local tmpfile = vim.fn.getcwd() .. "/." .. vim.fn.bufname()
  vim.fn.writefile(script, tmpfile)
  vim.cmd.call([[SendCmdToR('source("]] .. tmpfile .. [["); invisible(file.remove("]] .. tmpfile .. [["))')]])
end

usercmd("PltSel", PltSel, {})


-- render selected lines in Rmd
local RdrSel = function()
  -- yaml header, css chunks and chunks with include=FALSE above the current line
  local searchUntil = math.max(vim.fn.search("^[ \t]*```[ ]*{r.*include=FALSE", "bncW"), vim.fn.search("^[ \t]*```[ ]*{css", "bncW"))
  local script = {}
  local insert = 0
  local lastChunk = 0
  for i=1,vim.fn.line("$") do
    if i==searchUntil then lastChunk = 1 end
    local line = vim.fn.getline(i)
    if insert==1 and (line=="---" or line=="```") then
      table.insert(script, line)
      if lastChunk==1 then break end
      insert = 0
      goto next
    end
    if line=="---" or string.match(line, "^[ \t]*```[ ]*{r.*include=FALSE") or string.match(line, "^[ \t]*```[ ]*{css") then insert = 1 end
    if insert==1 then table.insert(script, line) end
    ::next::
  end
  -- selected lines or current line
  local lines = vim.fn.getline(vim.fn.line("v"), vim.fn.line("."))
  -- decides whether need to wrap the selection in an R code chunk
  local wrap = true
  for _,line in ipairs(lines) do
    if string.match(line, "```{r") then
      wrap = false
      break
    end
  end
  if wrap then
    local chunkline = vim.fn.search("^[ \t]*```[ ]*{r", "bncW")
    table.insert(lines, 1, vim.fn.getline(chunkline))
    table.insert(lines, "```")
  end
  for _,line in ipairs(lines) do
    table.insert(script, line)
  end
  -- write to temp file, render it, then remove it
  local tmpfile = vim.fn.getcwd() .. "/." .. vim.fn.bufname()
  vim.fn.writefile(script, tmpfile)
  vim.cmd.call([[SendCmdToR('rmarkdown::render("]] .. tmpfile .. [[", quiet=TRUE); invisible(file.remove("]] .. tmpfile .. [["))')]])
end

usercmd("RdrSel", RdrSel, {})
