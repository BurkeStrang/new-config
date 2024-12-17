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
          color = { fg = "#225500" }, -- light green
        },
      },
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          path = 1,
          color = { fg = "#225555" }, -- light teal
        },
      },
      lualine_x = {},
      lualine_y = {
        {
          "progress",
          color = { fg = "#225500" }, -- light green
        },
      },
      lualine_z = {
        {
          function()
            return os.date("%I:%M %p")
          end,
          color = { fg = "#225555" }, -- lightl teal
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
