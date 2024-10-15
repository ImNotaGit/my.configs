return {

  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot", "Copilot status", "Copilot toggle" },
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true, -- disable panel to use copilot-cmp
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "right", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = false, -- disable suggestion to use copilot-cmp
          auto_trigger = false, -- if false, need to use the next and prev keymap defined below to trigger suggestion
          debounce = 75,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<Esc>",
          },
        },
        filetypes = {
          ["*"] = false, -- now I disable for all filetypes by default; need to manually toggle Copilot as needed
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          txt = false,
          cvs = false,
          tsv = false,
          ["."] = false,
        },
        copilot_node_command = '/SFS/product/nodejs/18.17.1/bin/node', -- Node.js version must be > 16.x
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 10, -- #completions for panel
              inlineSuggestCount = 5, -- #completions for getCompletions
            }
          },
        },
      })
    end,
    keys = {
      {mode={"n","i"}, "<LocalLeader>cs", "<Cmd>Copilot status<CR>"},
      {mode={"n","i"}, "<LocalLeader>ct", "<Cmd>Copilot! toggle<CR>"},
    },
  },

  {
    "zbirenbaum/copilot-cmp",
    cmd = { "Copilot", "Copilot status", "Copilot toggle" },
    opts = {},
  },

}
