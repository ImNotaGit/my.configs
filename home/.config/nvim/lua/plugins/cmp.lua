return {

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "FelipeLema/cmp-async-path",
        "hrsh7th/cmp-cmdline",
      }
    },
    opts = function()
      dofile(vim.g.base46_cache .. "cmp")
      local cmp = require("cmp")
      local options = {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt="menu,menuone,noinsert,noselect",
        },
        mapping = {
          -- trigger menu
          ['<C-Space>'] = {
            i = cmp.mapping.complete(),
            c = cmp.mapping.complete(),
          },
          -- select items in completion list; below is the only way that I could make it work in multiple modes w/o messing up mappings outside of cmp
          ["<Up>"] = {
            i = cmp.mapping.select_prev_item(),
            c = cmp.mapping.select_prev_item(),
          },
          ["<Down>"] = {
            i = cmp.mapping.select_next_item(),
            c = cmp.mapping.select_next_item(),
          },
          -- scroll documentation up and down
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          -- confirm completion; only confirm expicitly selected item
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "c" }),
          -- abort completion with Alt+Backspace
          ["<M-BS>"] = {
            i = cmp.mapping.abort(),
            c = cmp.mapping.abort(),
          },
          -- close completion list
          ["<C-e>"] = {
            i = cmp.mapping.close(),
            c = cmp.mapping.close(),
          },
          -- use Tab for Copilot completion when Copilot suggestion is visible, but otherwise fall back to default Tab behavior
          ["<Tab>"] = {
            i = function(fallback)
              if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
              elseif cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              else
                fallback()
              end
            end,
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              else
                fallback()
              end
            end,
          },
          ["<S-Tab>"] = {
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              else
                fallback()
              end
            end,
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              else
                fallback()
              end
            end,
          },
        },
        sources = cmp.config.sources({
          { name = "copilot", keyword_length=0 },
          { name = "luasnip" },
          { name = "cmp_nvim_r" },
          { name = "nvim_lsp" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
          { name = "nvim_lua" },
          { name = "async_path" },
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            require("copilot_cmp.comparators").prioritize,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }
      return vim.tbl_deep_extend("force", options, require "nvchad.cmp")
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        sources = {
          { name = "buffer" },
        },
      })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = "async_path" }, -- path first
        }, {
          { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },

}
