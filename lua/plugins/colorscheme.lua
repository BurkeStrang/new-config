return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = function(_, opts)
      -- base options
      opts.transparent = true
      -- opts.italic_comments = true
      opts.borderless_picker = true
      opts.hide_fillchars = true
      opts.cache = true


      -- Cooler tilt: more green + blue, still muted
      opts.colors = {
        fg        = "#799FD9", -- desaturated blue-gray
        blue      = "#9080E0", -- cooler, more blue than purple
        cyan      = "#5CC8D7", -- blue-leaning cyan
        diag      = "#4FB9BF", -- teal-ish for hints
        green     = "#5B9B9F", -- cool green/teal
        darkgreen = "#3C6E71", -- deep teal-green
        orange    = "#3A9B8D", -- keep warm accent teal-leaning
        yellow    = "#C9A86D",
        red       = "#D1636E",
        pink      = "#9B8AD8", -- toned down
        purple    = "#8E90D3", -- cooler purple
        magenta   = "#7B84B8", -- desaturated blue-magenta
        gray      = "#5A6272",
        spellgrey = "#6B7089",
        darkgray  = "#909090",
      }

      opts.highlight = opts.highlight or {}

      opts.overrides = function(colors)
        local none = "NONE"
        return {
          ---------------------------------------------------------------------
          -- UI / Editor
          ---------------------------------------------------------------------
          Normal         = { fg = colors.fg, bg = none },
          NormalNC       = { fg = colors.fg, bg = none },
          NormalFloat    = { fg = colors.fg, bg = none },
          FloatBorder    = { fg = colors.gray, bg = none },
          WinSeparator   = { fg = colors.gray, bg = none },
          VertSplit      = { fg = colors.gray, bg = none },

          SignColumn     = { bg = none },
          LineNr         = { fg = colors.gray, bg = none },
          -- CursorLine     = { bg = none },
          -- CursorLineNr   = { fg = colors.cyan, bold = true, bg = none },
          -- CursorColumn   = { bg = none },
          -- ColorColumn    = { bg = none },
          Folded         = { fg = colors.gray, bg = none },
          FoldColumn     = { fg = colors.gray, bg = none },
          -- Whitespace     = { fg = colors.darkgray },

          StatusLine                  = { fg = colors.fg, bg = none },
          StatusLineNC                = { fg = colors.gray, bg = none },
          TabLine                     = { fg = colors.gray, bg = none },
          TabLineSel                  = { fg = colors.fg, bold = true, bg = none },
          TabLineFill                 = { bg = none },

          Pmenu          = { fg = colors.fg, bg = none },
          PmenuSel       = { fg = colors.blue, bg = none, bold = true },
          PmenuSbar      = { bg = none },
          PmenuThumb     = { bg = colors.gray },

          -- Search         = { fg = colors.cyan, bg = none, underline = true },
          -- IncSearch      = { fg = colors.blue, bg = none, underline = true },
          -- MatchParen     = { fg = colors.cyan, bg = none, underline = true },
          -- Visual         = { bg = none, reverse = true },

          ---------------------------------------------------------------------
          -- Classic Syntax (shifted to green/blue)
          ---------------------------------------------------------------------
          String         = { fg = colors.green },      -- was orange
          Character      = { fg = colors.green },
          Number         = { fg = colors.blue },       -- was purple
          Float          = { fg = colors.blue },
          Boolean        = { fg = colors.cyan },
          Constant       = { fg = colors.cyan },

          Type           = { fg = colors.green },      -- was magenta
          Structure      = { fg = colors.blue },
          StorageClass   = { fg = colors.cyan },
          Typedef        = { fg = colors.green },

          Operator       = { fg = colors.blue },
          Keyword        = { fg = colors.cyan },       -- cooler keywords
          Conditional    = { fg = colors.cyan },
          Repeat         = { fg = colors.cyan },

          Identifier     = { fg = colors.blue },       -- was purple
          Function       = { fg = colors.blue },
          Delimiter      = { fg = colors.darkgreen },
          Comment        = { fg = colors.gray, italic = false },

          ---------------------------------------------------------------------
          -- Treesitter (@ groups) - green/blue emphasis
          ---------------------------------------------------------------------
          ["@variable"]                = { fg = colors.fg },
          ["@variable.builtin"]       = { fg = colors.blue },
          ["@constant"]               = { fg = colors.cyan },
          ["@constant.builtin"]       = { fg = colors.cyan, bold = true },
          ["@property"]               = { fg = colors.blue },
          ["@field"]                  = { fg = colors.blue },
          ["@parameter"]              = { fg = colors.green },
          ["@namespace"]              = { fg = colors.blue },

          ["@type"]                   = { fg = colors.green },
          ["@type.builtin"]           = { fg = colors.green, bold = true },
          ["@type.qualifier"]         = { fg = colors.cyan },

          ["@function"]               = { fg = colors.blue },
          ["@function.method"]        = { fg = colors.blue },
          ["@constructor"]            = { fg = colors.blue },

          ["@keyword"]                = { fg = colors.cyan },
          ["@keyword.return"]         = { fg = colors.cyan },
          ["@keyword.function"]       = { fg = colors.cyan },

          ["@string"]                 = { fg = colors.green },
          ["@string.escape"]          = { fg = colors.cyan },
          ["@number"]                 = { fg = colors.blue },
          ["@boolean"]                = { fg = colors.cyan },

          ---------------------------------------------------------------------
          -- LSP & Diagnostics
          ---------------------------------------------------------------------
          DiagnosticError             = { fg = colors.red },
          DiagnosticWarn              = { fg = colors.yellow },
          DiagnosticInfo              = { fg = colors.blue },
          DiagnosticHint              = { fg = colors.diag },

          DiagnosticSignError         = { fg = colors.red, bg = none },
          DiagnosticSignWarn          = { fg = colors.yellow, bg = none },
          DiagnosticSignInfo          = { fg = colors.blue, bg = none },
          DiagnosticSignHint          = { fg = colors.diag, bg = none },

          DiagnosticUnderlineError    = { undercurl = true, sp = colors.red },
          DiagnosticUnderlineWarn     = { undercurl = true, sp = colors.yellow },
          DiagnosticUnderlineInfo     = { undercurl = true, sp = colors.blue },
          DiagnosticUnderlineHint     = { undercurl = true, sp = colors.diag },

          -- LspReferenceText            = { bg = none, underline = true },
          -- LspReferenceRead            = { bg = none, underline = true },
          -- LspReferenceWrite           = { bg = none, underline = true },
          -- LspInlayHint                = { fg = colors.darkgray, bg = none, italic = true },
          -- LspSignatureActiveParameter = { fg = colors.green, underline = true },

          ---------------------------------------------------------------------
          -- Diff/Git (more green/blue)
          ---------------------------------------------------------------------
          DiffAdd     = { fg = colors.green, bg = none },
          DiffChange  = { fg = colors.blue,  bg = none },
          DiffDelete  = { fg = colors.red,   bg = none },
          DiffText    = { fg = colors.cyan,  bg = none },

          -- Gitsigns
          GitSignsAdd    = { fg = colors.orange, bg = none },   -- was orange
          GitSignsChange = { fg = colors.blue,  bg = none },   -- was green
          GitSignsDelete = { fg = colors.red,   bg = none },

          ---------------------------------------------------------------------
          -- Neo-tree (lean into green/blue)
          ---------------------------------------------------------------------
          NeoTreeNormal           = { fg = colors.purple, bg = none },
          NeoTreeNormalNC         = { fg = colors.purple, bg = none },
          NeoTreeDirectoryName    = { fg = colors.fg },
          NeoTreeDirectoryIcon    = { fg = colors.cyan },
          NeoTreeFileName         = { fg = colors.fg },

          NeoTreeGitAdded         = { fg = colors.orange },      -- was orange
          NeoTreeGitUnstaged      = { fg = colors.orange },
          NeoTreeGitModified      = { fg = colors.blue },
          NeoTreeGitDeleted       = { fg = colors.red },
          NeoTreeGitRenamed       = { fg = colors.cyan },
          NeoTreeGitUnmerged      = { fg = colors.red },
          NeoTreeGitIgnored       = { fg = colors.gray },
          NeoTreeGitUntracked     = { fg = colors.orange },

          ---------------------------------------------------------------------
          -- Telescope
          ---------------------------------------------------------------------
          TelescopeNormal         = { fg = colors.fg, bg = none },
          TelescopeBorder         = { fg = colors.gray, bg = none },
          TelescopePromptNormal   = { fg = colors.fg, bg = none },
          TelescopePromptBorder   = { fg = colors.gray, bg = none },
          TelescopeTitle          = { fg = colors.blue, bold = true },
          TelescopeSelection      = { fg = colors.green, bg = none, bold = true },
          TelescopeMatching       = { fg = colors.cyan, bold = true },

          ---------------------------------------------------------------------
          -- WhichKey / CMP
          ---------------------------------------------------------------------
          WhichKey          = { fg = colors.blue },
          WhichKeyGroup     = { fg = colors.cyan },
          WhichKeyDesc      = { fg = colors.fg },
          WhichKeySeparator = { fg = colors.gray },

          CmpItemAbbr       = { fg = colors.fg },
          CmpItemAbbrMatch  = { fg = colors.blue, bold = true },
          CmpItemKind       = { fg = colors.green },
          CmpBorder         = { fg = colors.gray, bg = none },

          ---------------------------------------------------------------------
          -- Spelling
          ---------------------------------------------------------------------
          -- SpellBad   = { undercurl = true, sp = colors.spellgrey },
          -- SpellCap   = { undercurl = true, sp = colors.spellgrey },
          -- SpellLocal = { undercurl = true, sp = colors.spellgrey },
          -- SpellRare  = { undercurl = true, sp = colors.spellgrey },
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
