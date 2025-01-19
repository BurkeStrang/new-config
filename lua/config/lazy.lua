local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--copilot enabled
vim.g.ai_cmp = true

--diagnostics
-- vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#CC7070", undercurl = true })


-- removes statuses and feedback in command line
vim.opt.laststatus = 0
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.statusline = " "
vim.opt.report = 9999
vim.opt.shortmess:append("c") -- Don't show ins-completion messages

-- updating some filetypes
vim.filetype.add({ extension = { props = "xml" } })
vim.filetype.add({ extension = { sln = "xml" } })
vim.filetype.add({ extension = { nswag = "json" } })
vim.filetype.add({ extension = { http = "http" } })
vim.filetype.add({ extension = { razor = "razor" } })
vim.filetype.add({ extension = { cshtml = "razor" } })


require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- for opening urls
vim.ui.open = function(url)
  -- Check if running in WSL
  local is_wsl = vim.fn.has("wsl") == 1

  if is_wsl then
    -- Use wslview in WSL
    vim.fn.system({ "wslview", url })
  else
    -- Use start in Windows
    vim.fn.system({ "cmd.exe", "/C", "start", url })
  end
end

-- for folding code
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = { "#region", "#endregion" }

-- for coloring of the cursor and cursorline
vim.cmd("highlight Visual ctermbg=0 guibg=#273c3f") -- Muted teal-blue for visual selection
-- vim.cmd("highlight Cursor guifg=#1c1c1c guibg=#5a7d7c") -- Soft contrast cursor with grey-green background
-- vim.opt.guicursor = "n-v-c:block-cursor,i-ci-ve:ver25-cursorinsert,r-cr-o:hor20"
vim.opt.cursorline = false
vim.cmd("highlight CursorLine guibg=#2b3b3b") -- Subtle green-blue background for cursor line
