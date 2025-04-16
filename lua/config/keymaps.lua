-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- does a diff for changes made before last save
local function diff_current_buf()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype

  -- get content from disk (original state)
  local original_content = vim.fn.readfile(vim.api.nvim_buf_get_name(buf))

  -- create vertical split and new scratch buffer
  vim.cmd("vsplit")
  local new_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, new_buf)

  -- set buffer content to original (saved file)
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, original_content)

  -- scratch buffer settings
  vim.bo[new_buf].buftype = "nofile"
  vim.bo[new_buf].buflisted = false
  vim.bo[new_buf].swapfile = false
  vim.bo[new_buf].readonly = true
  vim.bo[new_buf].filetype = ft

  -- set diffopt explicitly for better diff handling
  vim.opt.diffopt:append("internal,algorithm:patience,indent-heuristic")

  -- enable diff mode explicitly for both buffers
  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")

  -- optional: jump to first diff
  vim.cmd("normal! ]c")
end

vim.keymap.set("n", "<leader>gd", diff_current_buf, { desc = "Diff Current Buffer" })

vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
