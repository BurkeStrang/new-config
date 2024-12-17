-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = ":,/,?",
  callback = function()
    vim.cmd("echo ''")
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("echo ''") -- Clears the command line without triggering ENTER prompt
    end, 10) -- Delay in milliseconds
  end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function()
    vim.cmd("echo ''")
  end,
})
