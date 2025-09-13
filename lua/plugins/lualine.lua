-- Keep the last real buffer name so sidebars can show it
local prev_bufname = nil

-- Sidebars/utility buffers we don't want to display directly
local sidebar_fts = {
  ["neo-tree"] = true,
  ["copilot-chat"] = true,
  ["neotest-summary"] = true,
  -- add others you use: ["trouble"] = true, ["lazy"] = true, etc.
}

local function is_sidebar_buf()
  local ft = vim.bo.filetype
  if sidebar_fts[ft] then return true end
  -- Any non-empty buftype (nofile, prompt, help, quickfix, terminal, etc.)
  local bt = vim.bo.buftype
  if bt ~= "" and bt ~= "acwrite" then return true end
  -- Fallback: match the display title used by neotest summary
  local title = vim.fn.expand("%:t")
  if title == "Neotest Summary" then return true end
  return false
end

-- Remember the last *real* buffer the user entered
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if not is_sidebar_buf() then
      local name = vim.fn.expand("%:~:.")
      if name ~= "" then
        prev_bufname = name
      end
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
      -- Optional: hide lualine entirely in these buffers
      -- disabled_filetypes = { statusline = { "neotest-summary", "neo-tree", "copilot-chat" } },
    },
    sections = {
      lualine_a = {
        { "branch", color = { fg = "#4B4F53" } },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          function()
            if is_sidebar_buf() and prev_bufname then
              return prev_bufname
            end
            local name = vim.fn.expand("%:~:.")
            if name == "" and prev_bufname then
              return prev_bufname
            end
            return name
          end,
          color = { fg = "#4B4F53" },
        },
      },
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {}, lualine_b = {}, lualine_c = {},
      lualine_x = {}, lualine_y = {}, lualine_z = {},
    },
    extensions = {},
  },
}
