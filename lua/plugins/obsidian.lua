return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "Burkes Notes",
        path = "/mnt/c/Users/burke/iCloudDrive/iCloud~md~obsidian/Burkes Notes/Burkes Notes",
      },
    },
    daily_notes = {
      folder = "Personal/Daily Planning", -- relative to vault root
      date_format = "%Y-%m-%d", -- adjust if Obsidian uses another format
      alias_format = "%B %-d, %Y", -- e.g. "September 6, 2025"
      -- template = "Templates/Daily.md", -- optional, relative to vault
    },
    mappings = {}, -- keep this if you're using obsidian.nvim’s built-in mappings
  },
}
