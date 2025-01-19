return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      section_separators = "",
      component_separators = "",
    },
    sections = {
      lualine_a = {
        {
          "branch",
          color = { fg = "#4B4F53" },
        },
      },
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          color = { fg = "#225555" },
        },
      },
      lualine_x = {},
      lualine_y = {
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          color_added = { fg = "#1CA191" },
          color_modified = { fg = "#0099CC" },
          color_removed = { fg = "#CC7070" },
        },
        {
          "progress",
          color = { fg = "#4B4F53" },
        },
      },
      lualine_z = {
        {
          function()
            return os.date("%I:%M %p")
          end,
          color = { fg = "#225555" },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {},
  },
}
