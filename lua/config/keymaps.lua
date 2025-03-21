-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- does a diff for changes made before last save
local function diff_current_buf()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local buf_content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  vim.cmd("vsplit")
  local new_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, new_buf)

  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, vim.fn.readfile(vim.api.nvim_buf_get_name(buf)))

  vim.bo[new_buf].buftype = "nofile"
  vim.bo[new_buf].buflisted = false
  vim.bo[new_buf].swapfile = false
  vim.bo[new_buf].readonly = true
  vim.bo[new_buf].filetype = ft

  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")
end

vim.keymap.set("n", "<leader>gd", diff_current_buf, { desc = "Diff Current Buffer" })
