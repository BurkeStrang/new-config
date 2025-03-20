-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- does a diff for changes made before last save
local function diff_current_buf()
  -- focus current buffer
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local curstate = vim.g.buffer_diff_state and vim.g.buffer_diff_state[bufnr]

  if not curstate or not vim.tbl_contains(vim.api.nvim_list_tabpages(), curstate) then
    -- reset if tabpage no longer valid
    vim.g.buffer_diff_state = vim.g.buffer_diff_state or {}
    vim.g.buffer_diff_state[bufnr] = nil
  else
    -- focus the existing diff tab
    vim.api.nvim_set_current_tabpage(curstate)
    return
  end

  -- create diff split
  vim.cmd(string.format([[
    tab split
    diffthis

    topleft vnew | read # | normal! 1Gdd
    setlocal buftype=nofile
    setlocal nobuflisted
    setlocal noswapfile
    setlocal readonly!
    setlocal filetype=%s
    diffthis

    wincmd p
  ]], ft))

  -- save the tabpage for the buffer
  vim.g.buffer_diff_state[bufnr] = vim.api.nvim_get_current_tabpage()
end

-- Keymap to trigger the diff function
vim.keymap.set('n', '<leader>gd', diff_current_buf, { desc = "Diff Current Buffer" })
