return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = function(_, opts)
      opts.transparent = true
      opts.italic_comments = true
      opts.borderless_telescope = false

      opts.theme = {
        colors = {
          fg = "#6C9EC8",
          blue = "#0099CC",
          cyan = "#5AC9C9",
          green = "#1CA191",
          orange = "#009090",
          yellow = "#C0AA60",
          red = "#CC7070",
          pink = "#8F65B4",
          purple = "#9370DB",
          magenta = "#4C8D8B",
        },

        highlight = {},

        overrides = function(colors)
          return {
            Number = { fg = colors.purple },
            Boolean = { fg = colors.pink },
            Type = { fg = colors.blue },
            Operator = { fg = colors.orange },
            Keyword = { fg = colors.orange },
            Identifier = { fg = colors.blue },
            Delimiter = { fg = colors.magenta },

            DiagnosticError = { fg = colors.red },
            DiagnosticWarn = { fg = colors.yellow },
            DiagnosticInfo = { fg = colors.blue },
            DiagnosticHint = { fg = colors.cyan },

            -- DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
            -- DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
            -- DiagnosticUnderlineInfo = { sp = colors.blue, undercurl = true },
            -- DiagnosticUnderlineHint = { sp = colors.cyan, undercurl = true },
          }
        end,
      }

      return opts
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
