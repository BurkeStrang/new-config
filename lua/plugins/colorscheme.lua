return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = function(_, opts)
      opts.transparent = true
      -- opts.italic_comments = true
      opts.borderless_picker = true
      opts.hide_fillchars = true
      opts.cache = true

      opts.colors = {
        fg = "#479DB4", -- Light Blue
        blue = "#1A96A0", -- Greenish Blue
        cyan = "#397B9F", -- Light Cyan
        diag = "#5AC9C9",
        green = "#1CA191", -- Teal Green
        orange = "#1A8BBA", -- Slightly Greenish Orange
        yellow = "#F08A60", -- Mustard Yellow
        red = "#A95555", -- Light Red
        pink = "#A0568E", -- Lavender
        purple = "#9370DB", -- Medium Purple
        magenta = "#80609F", -- Darker Muted Magenta
        gray = "#464B68", -- Dark Gray
        darkgreen = "#907D85", -- this is really orange
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
          Delimiter = { fg = colors.darkgreen },
          Comment = { fg = colors.gray, italic = true },

          DiagnosticError = { fg = colors.red },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticInfo = { fg = colors.blue },
          DiagnosticHint = { fg = colors.diag },

          LineNr = { fg = colors.gray },

          -- NeoTree Git Highlight Groups
          NeoTreeGitAdded = { fg = colors.orange },
          NeoTreeGitUnstaged = { fg = colors.orange },
          NeoTreeGitModified = { fg = colors.blue },
          NeoTreeGitDeleted = { fg = colors.red },
          NeoTreeGitRenamed = { fg = colors.pink },
          NeoTreeGitUnmerged = { fg = colors.red },
          NeoTreeGitIgnored = { fg = colors.gray },
          NeoTreeGitUntracked = { fg = colors.orange },

          -- Gitsigns Highlight Groups
          GitSignsAdd = { fg = colors.orange },
          GitSignsChange = { fg = colors.green },
          GitSignsDelete = { fg = colors.red },

          -- NeoTree Folder Highlight Group
          NeoTreeDirectoryName = { fg = colors.darkgreen },
          NeoTreeDirectoryIcon = { fg = colors.darkgreen },
          NeoTreeFileName = { fg = colors.darkgreen },
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
