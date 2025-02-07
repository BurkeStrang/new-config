return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = function(_, opts)
      opts.transparent = true
      opts.italic_comments = true
      opts.borderless_picker = true

      opts.colors = {
        fg = "#479DB4", -- Light Blue
        blue = "#1A8BBA", -- Bright Blue
        -- fg = "#B37AB5", -- Bright Blue
        -- blue = "#4C9EC8", -- Light Blue
        cyan = "#5AC9C9", -- Light Cyan
        green = "#1CA191", -- Teal Green
        orange = "#009090", -- Dark Cyan
        yellow = "#F08A60", -- Mustard Yellow
        red = "#CC7070", -- Light Red
        pink = "#A0568E", -- Lavender
        purple = "#9370DB", -- Medium Purple
        magenta = "#4C8D8B", -- Dark Teal
      }

      opts.highlight = {}

      opts.overrides = function(colors)
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

          LineNr = { fg = "#464B68" },

          -- NeoTree Git Highlight Groups
          NeoTreeGitAdded = { fg = colors.green },
          NeoTreeGitUnstaged = { fg = colors.green },
          NeoTreeGitModified = { fg = colors.blue },
          NeoTreeGitDeleted = { fg = colors.red },
          NeoTreeGitRenamed = { fg = colors.pink },
          NeoTreeGitUnmerged = { fg = colors.red },
          NeoTreeGitIgnored = { fg = colors.gray },
          NeoTreeGitUntracked = { fg = colors.green },

          -- Gitsigns Highlight Groups
          GitSignsAdd = { fg = colors.green },
          GitSignsChange = { fg = colors.blue },
          GitSignsDelete = { fg = colors.red },

          -- NeoTree Folder Highlight Group
          NeoTreeDirectoryName = { fg = colors.purple },
          NeoTreeDirectoryIcon = { fg = colors.purple },
        }
      end
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
