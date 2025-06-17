local prev_bufname = nil

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.filetype ~= "neo-tree" and vim.bo.filetype ~= "copilot-chat" then
      prev_bufname = vim.fn.expand("%:~:.")
    end
  end,
})

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
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        -- {
        --   "diff",
        --   symbols = { added = " ", modified = " ", removed = " " },
        --   color_added = { fg = "#1CA191" },
        --   color_modified = { fg = "#0099CC" },
        --   color_removed = { fg = "#CC7070" },
        -- },
        {
          function()
            local ft = vim.bo.filetype
            if (ft == "neo-tree" or ft == "copilot-chat")  and prev_bufname then
              return prev_bufname
            else
              return vim.fn.expand("%:~:.")
            end
          end,
          color = { fg = "#225555" },
        },
      },
      lualine_z = {},
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
