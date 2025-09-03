local prev_bufname = nil
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local filetype = vim.bo.filetype
    local bufname = vim.fn.expand("%")

    -- Check if this is a buffer we want to ignore
    local should_ignore = filetype == "copilot-chat" or
        filetype == "neo-tree" or
        (filetype == "neo-tree" and (
          string.match(bufname, "buffers") or
          string.match(bufname, "git_status")
        ))

    if not should_ignore then
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
        {
          function()
            local ft = vim.bo.filetype
            local bufname = vim.fn.expand("%")

            -- Show previous buffer name for ignored buffer types
            if (ft == "neo-tree" or ft == "copilot-chat") and prev_bufname then
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
