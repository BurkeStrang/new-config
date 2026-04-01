return {
  {
    "nvim-mini/mini.icons",
    opts = function(_, opts)
      opts.filetype = opts.filetype or {}
      opts.extension = opts.extension or {}

      -- filetype-based (these worked)
      opts.filetype["cshtml"] = {
        glyph = "󰫐",
        hl = "MiniIconsPurple",
      }

      opts.filetype["razor"] = {
        glyph = "󰫐",
        hl = "MiniIconsPurple",
      }

      -- extension-based (this fixes slnx)
      opts.extension["slnx"] = {
        glyph = "󰫐",
        hl = "MiniIconsPurple",
      }
    end,
  },
}
