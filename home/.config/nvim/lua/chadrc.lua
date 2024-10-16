-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

local M = {}

---@type ChadrcConfig
M.base46 = {
  theme = "jellybeans",
  hl_override = {
    -- ["@comment"] = { italic = true },
    -- Comment = { italic = true, fg = "#7f7f7f", bg = "#1a1a1a" }, -- somehow italic has no effect but when it's there (regardless of true/false), the fg and bg colors got reversed
    Comment = { fg = "#7f7f7f", bg = "#1a1a1a" },
    CursorLine = {bg = "#262626" },
    CursorColumn = { bg = "#262626" },
    WinSeparator = { fg = "#b3b3b3" },
    SpecialKey = { fg = "#7f7f7f" },
    NoneText = { fg = "#7f7f7f" },
    cmdlineInput = { fg = "#d9d9c4", bg = "#1a1a1a" }, -- vimcmdline, but somehow has no effect and still linked to Comment color
    rError = { fg = "#ff0000", bg = "#335533" }, -- Nvim-R, but somehow has not effect and still linked to Error color, so I changed Error color below
    Error = { fg = "#ff0000", bg = "#335533" },
  },
  -- hl_add = {
  --   NvimTreeOpenedFolderName = { fg = "green", bold = true },
  -- },
}

return M
