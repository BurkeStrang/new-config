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
           fg = "#4C9EC8", -- Light Blue
           blue = "#0099CC", -- Bright Blue
           cyan = "#5AC9C9", -- Light Cyan
           green = "#1CA191", -- Teal Green
           orange = "#009090", -- Dark Cyan
           yellow = "#C0AA60", -- Mustard Yellow
           red = "#CC7070", -- Light Red
           pink = "#8F65B4", -- Lavender
           purple = "#9370DB", -- Medium Purple
           magenta = "#4C8D8B", -- Dark Teal
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
