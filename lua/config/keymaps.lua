-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--

local function git_diff_current_buf()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local file_path = vim.api.nvim_buf_get_name(buf)
  -- check if file exists and is in a git repository
  if file_path == "" then
    vim.notify("Buffer has no file name", vim.log.levels.WARN)
    return
  end
  -- get content from last git commit
  local git_cmd = string.format("git show HEAD:%s", vim.fn.fnamemodify(file_path, ":~:."))
  local git_content = vim.fn.systemlist(git_cmd)
  -- check if git command was successful
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get git content: " .. table.concat(git_content, "\n"), vim.log.levels.ERROR)
    return
  end
  
  local buffer_name = string.format("[previous] %s", vim.fn.fnamemodify(file_path, ":t"))
  
  -- check if buffer with this name already exists
  local existing_buf = vim.fn.bufnr(buffer_name)
  if existing_buf ~= -1 then
    -- close any windows showing the existing buffer
    local windows = vim.fn.win_findbuf(existing_buf)
    for _, win in ipairs(windows) do
      vim.api.nvim_win_close(win, false)
    end
    -- delete the existing buffer
    vim.api.nvim_buf_delete(existing_buf, { force = true })
  end
  
  -- create vertical split and new scratch buffer
  vim.cmd("vsplit")
  local new_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, new_buf)
  -- set buffer content to git HEAD version
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, git_content)
  -- scratch buffer settings
  vim.bo[new_buf].buftype = "nofile"
  vim.bo[new_buf].buflisted = false
  vim.bo[new_buf].swapfile = false
  vim.bo[new_buf].readonly = true
  vim.bo[new_buf].filetype = ft
  -- set buffer name to indicate it's the previous version
  vim.api.nvim_buf_set_name(new_buf, buffer_name)
  -- set diffopt explicitly for better diff handling
  vim.opt.diffopt:append("internal,algorithm:patience,indent-heuristic")
  -- enable diff mode explicitly for both buffers
  vim.cmd("diffthis")
  vim.cmd("wincmd p")
  vim.cmd("diffthis")
  -- optional: jump to first diff
  vim.cmd("normal! ]c")
end

vim.keymap.set("n", "<leader>gD", git_diff_current_buf, { desc = "Git Diff Current Buffer" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
