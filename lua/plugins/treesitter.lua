return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  version = false, -- last release is way too old and doesn't work on Windows
  build = function()
    local TS = require("nvim-treesitter")
    if not TS.get_installed then
      LazyVim.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
      return
    end
    LazyVim.treesitter.ensure_treesitter_cli(function()
      TS.update(nil, { summary = true })
    end)
  end,
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  event = { "LazyFile", "VeryLazy" },
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  opts_extend = { "ensure_installed" },

  ---@class lazyvim.TSConfig: TSConfig
  opts = {
    indent = { enable = true },
    highlight = { enable = true },
    folds = { enable = true },

    ensure_installed = {
      -- core languages
      "bash", "bicep", "c", "c_sharp", "diff", "go", "html", "http",
      "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "luap",
      "markdown", "markdown_inline", "printf", "python", "powershell",
      "query", "razor", "regex", "rust", "toml", "tsx", "typescript",
      "vim", "vimdoc", "xml", "yaml", "zig",
    },

    -- incremental selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },

    -- textobjects (functions, classes, params)
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["]A"] = "@parameter.inner",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["[A"] = "@parameter.inner",
        },
      },
    },
  },

  ---@param opts lazyvim.TSConfig
  config = function(_, opts)
    local TS = require("nvim-treesitter")

    setmetatable(require("nvim-treesitter.install"), {
      __newindex = function(_, k)
        if k == "compilers" then
          vim.schedule(function()
            LazyVim.error({
              "Setting custom compilers for `nvim-treesitter` is no longer supported.",
              "",
              "For more info, see:",
              "- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
            })
          end)
        end
      end,
    })

    if not TS.get_installed then
      return LazyVim.error("Please use `:Lazy` and update `nvim-treesitter`")
    elseif type(opts.ensure_installed) ~= "table" then
      return LazyVim.error("`nvim-treesitter` opts.ensure_installed must be a table")
    end

    -- setup treesitter
    TS.setup(opts)
    LazyVim.treesitter.get_installed(true)

    -- install missing parsers
    local install = vim.tbl_filter(function(lang)
      return not LazyVim.treesitter.have(lang)
    end, opts.ensure_installed or {})

    if #install > 0 then
      LazyVim.treesitter.ensure_treesitter_cli(function()
        TS.install(install, { summary = true }):await(function()
          LazyVim.treesitter.get_installed(true)
        end)
      end)
    end

    -- runtime behavior hooks
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
      callback = function(ev)
        if not LazyVim.treesitter.have(ev.match) then
          return
        end

        -- highlighting
        if vim.tbl_get(opts, "highlight", "enable") ~= false then
          pcall(vim.treesitter.start)
        end

        -- indents
        if vim.tbl_get(opts, "indent", "enable") ~= false and LazyVim.treesitter.have(ev.match, "indents") then
          LazyVim.set_default("indentexpr", "v:lua.LazyVim.treesitter.indentexpr()")
        end

        -- folds
        if vim.tbl_get(opts, "folds", "enable") ~= false and LazyVim.treesitter.have(ev.match, "folds") then
          if LazyVim.set_default("foldmethod", "expr") then
            LazyVim.set_default("foldexpr", "v:lua.LazyVim.treesitter.foldexpr()")
          end
        end
      end,
    })
  end,
}
