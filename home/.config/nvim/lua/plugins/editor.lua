return {

  -- remember last edit position
  {
    "vladdoster/remember.nvim",
    lazy = false,
    opts = {},
  },

  -- key mapping without delay
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {},
  },

  -- change which-key (key mapping reminder) options
  {
    "folke/which-key.nvim",
    opts = {
      triggers_blacklist = {
        i = { "j", "k", ".", "..", '"', '""', "'", "''", "`", "``", "(", "()", "[", "[]", "{", "{}", "-" },
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require("which-key").setup(opts)
    end,
  },

  -- fzf for telescope
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build="make",
  },

  -- file browser for telescope
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- change telescope (fuzzy finder) options
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = function()
      dofile(vim.g.base46_cache .. "telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      local actions_state = require("telescope.actions.state")
      -- I copied the defaults and extensions_list from NvChad config; I needed to do this because I needed opts as a function to declare local fb_actions above to customize key mappings for the file_browser extension (otherwise, if I require the fb_actions inline in the mappings the extension could not be found)
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          entry_prefix = " ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          mappings = {
            n = { ["q"] = actions.close },
          },
        },
        extensions_list = { "themes", "terms" },
        pickers = {
          find_files = {
            -- find_command = { "find", ".", "..", "-type", "f" }, -- for find_files, include files in the parent
            mappings = {
              i = {
                ["<M-CR>"] = actions.select_vertical,
              },
            },
          },
          oldfiles = {
            mappings = {
              i = {
                ["<M-CR>"] = actions.select_vertical,
              },
            },
          },
        },
        extensions = {
          file_browser = {
            grouped = true,
            hidden = { file_browser = true, folder_browser = true },
            mappings = {
              i = {
                ["<C-h>"] = fb_actions.goto_home_dir,
                ["<M-CR>"] = actions.select_vertical,
                -- initiate fzf search from the selected dir (assuming a dir is selected, not a file)
                ["<C-f>"] = function(prompt_bufnr)
                  local path = actions_state.get_selected_entry().value
                  actions.close(prompt_bufnr)
                  vim.cmd("FzfLua files cwd=" .. path)
                  vim.cmd("startinsert")
                end,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
    keys = {
      { mode={"n"}, "<Leader>fe", ":Telescope file_browser<CR>" },
      { mode={"n"}, "<Leader>fE", ":Telescope file_browser path=" },
    },
  },

  -- fzf fuzzy finder, I use this as a faster alternative to telescope but keep telescope for certain functions
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        fzf_colors = true,
        winopts = {
          height = 0.9,
          width = 0.9,
          row = 0.5,
          col = 0.5,
          preview = {
            wrap = "wrap",
            layout = "vertical",
            vertical = "down:50%",
          },
        },
        actions = {
          files = {
            ["enter"] = actions.file_edit,
            ["alt-enter"] = actions.file_vsplit,
          },
        },
        files = {
          previewer = false,
          cwd_prompt = false,
          -- this find command option below exclude binary files with grep -I, but this is too slow
          --find_opts = [[\( -type f -o -name .git -prune -o -name .hg -prune -o -name .work -prune -o -name '.snakemake*' -prune -o -name logs -prune -o -name tmp -prune \) -not -name .git -not -name .hg -not -name .work -not -name '.snakemake*' -not -name logs -not -name tmp -not -name '*.html' -not -name '*.xml' -not -name '*.xlsx' -exec grep -Iq '.' {} \; -printf '%P\n']],
          find_opts = [[\( -type f -o -name .git -prune -o -name .hg -prune -o -name .work -prune -o -name '.snakemake*' -prune -o -name logs -prune -o -name tmp -prune \) -not -name .git -not -name .hg -not -name .work -not -name '.snakemake*' -not -name logs -not -name tmp -not -name '*.gz' -not -name '*.fastq*' -not -name '*.fq*' -not -name '*.bam*' -not -name '*.RDS' -not -name '*.RData' -not -name '*.png' -not -name '*.pdf' -not -name '*.html' -not -name '*.xml' -not -name '*.xlsx' -not -name DONE -printf '%P\n']],
        },
        grep = {
          -- need \\ to escape
          grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --exclude={\\*.html,\\*.log,\\*.o,\\*.e} --exclude-dir={.git,.hg,.work,.snakemake\\*,logs,tmp} --perl-regexp -e",
        },
      }
    end,
    keys = {
      { mode={"n"}, "<Leader>ff", ":FzfLua files<CR>" },
      { mode={"n"}, "<Leader>fd", ":FzfLua files cwd=" },
      { mode={"n"}, "<Leader>fo", ":FzfLua oldfiles<CR>" },
      { mode={"n"}, "<Leader>fw", ":FzfLua live_grep<CR>" },
      { mode={"n"}, "<Leader>fW", ":FzfLua live_grep cwd=" },
    },
  },

  -- change nvim-tree (file browser) options; I have disabled this since I don't use it much
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    keys = {
      { mode={"n"}, "<C-g>", require("nvim-tree.api").tree.change_root_to_parent }, -- change root to parent dir
    },
  },

  -- extended a/i textobjects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {
      -- note: these custom text objects only work with i/a prefix during e.g. selection
      custom_textobjects = {
        -- refined definition of WORD: do not allow ',' in WORD
        -- cannot distinguish between iW and aW, this is not important anyway
        W = { { '[%s,]+[^%s,]+', '^%s*[^%s,]+' }, '^[%s,]*()().*()()$' },
        -- a variation of the W above: starting right from the point of cursor (ignoring anything to the left)
        E = { '[^%s,]+' },
        -- modify ')', ']' to include leading word; for ')' allow the word to be valid function name; for ']' allow the word to be valid object name
        [')'] = { { '[%s({]+[%w_.:$]+%b()', '^%s*[%w_.:$]+%b()' }, '^[%s({]*()().*()()$' },
        [']'] = { { '[%s([{]+[%w_.$@]+%b[]', '^%s*[%w_.$@]+%b[]' }, '^[%s([{]*()().*()()$' },
        -- ')' or ']'
        B = { { '[%s({]+[%w_.:$]+%b()', '^%s*[%w_.:$]+%b()', '[%s([{]+[%w_.$@]+%b[]', '^%s*[%w_.$@]+%b[]' }, '^[%s([{]*()().*()()$' },
        -- a variation of the B above: starting right from the point of cursor (ignoring anything to the left)
        V = { { '[%w_.:$]+%b()', '[%w_.$@]+%b[]' } },
      },
      -- Number of lines within which textobject is searched
      n_lines = 1,
      search_method = "cover_or_nearest",
      silent = true,
    },
  },

  -- extend f, F, t, T to work on multiple lines, with repeated jumps (using ";")
  {
    "echasnovski/mini.jump",
    event = "VeryLazy",
    opts = {},
  },

  -- fast searching and jumping to text
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      -- the default maps key "s", which I use for surround, so I uses "t" instead (I don't use the default "t" key for jumping)
      vim.keymap.set({"n", "x", "o"}, "t",  "<Plug>(leap-forward)")
      vim.keymap.set({"n", "x", "o"}, "T",  "<Plug>(leap-backward)")
      vim.keymap.set({"n", "x", "o"}, "gt", "<Plug>(leap-from-window)")
    end,
  },

  -- move lines etc.
  {
    "fedepujol/move.nvim",
    event = "VeryLazy",
    opts = {
      -- enable moving (and auto indentation when applicable) for various text objects
      line = { enable = true, indent = true },
      block = { enable = true, indent = true },
      word = { enable = true },
      char = { enable = true },
    },
    keys = {
      { mode = "n", "<A-j>", ":MoveLine(1)<CR>", noremap = true, silent = true },
      { mode = "n", "<A-k>", ":MoveLine(-1)<CR>", noremap = true, silent = true },
      { mode = "n", "<A-h>", ":MoveHChar(-1)<CR>", noremap = true, silent = true }, -- this got overridden by NvChad defaults, I had to add this to ../configs/keymaps.lua as well
      { mode = "n", "<A-l>", ":MoveHChar(1)<CR>", noremap = true, silent = true },
      { mode = "n", "<A-.>", ":MoveWord(1)<CR>", noremap = true, silent = true },
      { mode = "n", "<A-,>", ":MoveWord(-1)<CR>", noremap = true, silent = true },
      { mode = "i", "<A-j>", "<Cmd>MoveLine(1)<CR>", noremap = true, silent = true },
      { mode = "i", "<A-k>", "<Cmd>MoveLine(-1)<CR>", noremap = true, silent = true },
      { mode = "i", "<A-h>", "<Cmd>MoveHChar(-1)<CR>", noremap = true, silent = true },
      { mode = "i", "<A-l>", "<Cmd>MoveHChar(1)<CR>", noremap = true, silent = true },
      { mode = "i", "<A-.>", "<Cmd>MoveWord(1)<CR>", noremap = true, silent = true },
      { mode = "i", "<A-,>", "<Cmd>MoveWord(-1)<CR>", noremap = true, silent = true },
      { mode = "v", "<A-j>", ":MoveBlock(1)<CR>", noremap = true, silent = true },
      { mode = "v", "<A-k>", ":MoveBlock(-1)<CR>", noremap = true, silent = true },
      { mode = "v", "<A-h>", ":MoveHBlock(-1)<CR>", noremap = true, silent = true },
      { mode = "v", "<A-l>", ":MoveHBlock(1)<CR>", noremap = true, silent = true },
    }
  },

  -- enable common vim keybindings in terminal
  {
    "chomosuke/term-edit.nvim",
    event = {event={"BufWinEnter", "WinEnter"}, pattern="term://*"},
    config = function()
      require("term-edit").setup({
        prompt_end = {'%$ ', '> '},
      })
    end,
  },

  -- color brackets etc.
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  -- auto-pairing brackets etc. NvChad uses windwp/nvim-autopairs by default but only in insert mode, and I modified it to enable it in terminal mode
  -- however, NvChad still loads windwp/nvim-autopairs and somehow I could not disable it, so need to replace windwp/nvim-autopairs with my version in ~/.local/share/nvim/lazy
  -- bash/zsh terminal has autopair as bash/zsh plugin, and I was using it only for R (Nvim-R) and python (via vimcmdline) terminal; but for R I later switched to radian which also has built-in autopair, so for now I keep this only for python
  -- currently I have it disabled since it appears to have a very minor conflict with ultimate-autopair.nvim below
  {
    "ImNotaGit/nvim-autopairs",
    enabled = false,
    -- ft = { "r", "rmd", "python" },
    ft = { "python" },
    config = function()
      require("nvim-autopairs").setup({
        map_cr = false,
      })
      vim.api.nvim_create_autocmd({"BufWinEnter", "WinEnter"}, {
        pattern = "term://*",
        command = "setlocal modifiable"
      })
    end,
  },

  -- nvim-autopairs (used by NvChad by default) did not work perfectly out of the box, and I was not sure how to customize it, so I used ultimate-autopair.nvim which worked for me out of the box; this does not seem to conflict with nvim-autopairs
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6", --recomended as each new version will have breaking changes
    opts = {}, -- this line is needed
    -- I tried to enable the experimental terminal mode autopair but it failed
    -- config = function(_, opts)
    --   local ua = require "ultimate-autopair"
    --   require "ultimate-autopair.core".modes={'i', 'c', 't'}
    --   -- ua.setup(opts)
    --   ua.init({{ua.extend_default(opts)}, {
    --     profile = require "ultimate-autopair.experimental.terminal".init
    --   }})
    -- end,
  },

  -- shortcuts for editing brackets etc.
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-s>", -- doesn't work; the default also doesn't work...
        normal = "s",
        normal_cur = "sl", -- for current line
        visual = "s",
      },
    },
    keys = {
      -- surround word
      { mode = "n", 's"', 'siw"', remap = true },
      { mode = "n", "s'", "siw'", remap = true },
      { mode = "n", "s`", "siw`", remap = true },
      { mode = "n", "s)", "siw)", remap = true },
      { mode = "n", "s]", "siw]", remap = true },
      { mode = "n", "s}", "siw}", remap = true },
      -- surround WORD (custom-defined via mini.ai)
      { mode = "n", 'ss"', 'siW"', remap = true },
      { mode = "n", "ss'", "siW'", remap = true },
      { mode = "n", "ss`", "siW`", remap = true },
      { mode = "n", "ss)", "siW)", remap = true },
      { mode = "n", "ss]", "siW]", remap = true },
      { mode = "n", "ss}", "siW}", remap = true },
      -- surround B (custom-defined via mini.ai)
      { mode = "n", "ss(", "siB)", remap = true },
      { mode = "n", "ss[", "siB]", remap = true },
      { mode = "n", "ss{", "siB}", remap = true },
      -- surround word starting from cursor in insert mode; in the end the cursor is placed after the last quote or before the last bracket
      { mode = "i", '""s', '<Esc>sw"lwa', remap = true },
      { mode = "i", "''s", "<Esc>sw'lwa", remap = true },
      { mode = "i", "``s", "<Esc>sw`lwa", remap = true },
      { mode = "i", "()s", "<Esc>sw)lwi", remap = true },
      { mode = "i", "[]s", "<Esc>sw]lwi", remap = true },
      { mode = "i", "{}s", "<Esc>sw}lwi", remap = true },
      -- surround WORD (the custom-defined 'E' text object via mini.ai) starting from cursor in insert mode
      { mode = "i", '""w', '<Esc>siE"Ea', remap = true },
      { mode = "i", "''w", "<Esc>siE'Ea", remap = true },
      { mode = "i", "``w", "<Esc>siE`Ea", remap = true },
      { mode = "i", "()w", "<Esc>siE)Ei", remap = true },
      { mode = "i", "[]w", "<Esc>siE]Ei", remap = true },
      { mode = "i", "{}w", "<Esc>siE}Ei", remap = true },
      -- surround V (custom-defined via mini.ai) starting from cursor in insert mode
      { mode = "i", "()b", "<Esc>siV)%i", remap = true },
      { mode = "i", "[]b", "<Esc>siV]%i", remap = true },
      { mode = "i", "{}b", "<Esc>siV}%i", remap = true },
      -- surround current line starting from cursor in insert mode; for {} assume it's a chunk so end with <CR> after the first bracelet (in R this will auto format into a chunk)
      { mode = "i", '""l', '<Esc>s$"A', remap = true },
      { mode = "i", "''l", "<Esc>s$'A", remap = true },
      { mode = "i", "``l", "<Esc>s$`A", remap = true },
      { mode = "i", "()j", "<Esc>s$)$i", remap = true }, -- change l to j as j is easier to type in the sequence
      { mode = "i", "[]l", "<Esc>s$]$i", remap = true },
      { mode = "i", "{}l", "<Esc>s$}a<CR>", remap = true },
    },
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },

  -- adding comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      -- lhs of toggle mappings in normal mode
      toggler = {
        -- line-comment toggle keymap
        line = "gc",
        -- block-comment toggle keymap
        block = "gb",
      },
      -- lhs of operator-pending mappings in normal and visual mode
      opleader = {
        -- line-comment keymap
        line = "gc",
        -- block-comment keymap
        block = "gb",
      },
    },
  },

}
