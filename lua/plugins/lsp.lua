return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    { "williamboman/mason-lspconfig.nvim", config = function() end },
    {
      "seblyng/roslyn.nvim",
      ft = { "cs", "razor" },
      dependencies = {
        {
          -- By loading as a dependencies, we ensure that we are available to set
          -- the handlers for roslyn
          "tris203/rzls.nvim",
          config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("rzls").setup({})
          end,
        },
      },
    },
  },
  opts = function()
    ---@class PluginLspOpts
    local ret = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
        exclude = { "vue", "c" }, -- filetypes for which you don't want to enable inlay hints
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        angularls = {},
        bashls = {},
        bicep = {},
        clangd = {},
        gopls = {},
        jsonls = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        pylsp = {},
        -- ruff_lsp = {},
        rust_analyzer = {},
        -- pyright = {
        --   settings = {
        --     python = {
        --       analysis = {
        --         autoSearchPaths = true,
        --         useLibraryCodeForTypes = true,
        --       },
        --     },
        --   },
        -- },
        -- cssls = {},
        jdtls = {},
        tailwindcss = {
          -- root_dir = function(...)
          --   return require("lspconfig.util").root_pattern(".git")(...)
          -- end,
        },
        -- quick_lint_js = {},
        vtsls = {},
        eslint = {},
        terraformls = {},
        -- ts_ls = {
          -- root_dir = function(...)
          --   return require("lspconfig.util").root_pattern(".git")(...)
          -- end,
          -- single_file_support = false,
          -- settings = {
          --   typescript = {
          --     inlayHints = {
          --       includeInlayParameterNameHints = "literal",
          --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          --       includeInlayFunctionParameterTypeHints = true,
          --       includeInlayVariableTypeHints = false,
          --       includeInlayPropertyDeclarationTypeHints = true,
          --       includeInlayFunctionLikeReturnTypeHints = true,
          --       includeInlayEnumMemberValueHints = true,
          --     },
          --   },
          --   javascript = {
          --     inlayHints = {
          --       includeInlayParameterNameHints = "all",
          --       includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          --       includeInlayFunctionParameterTypeHints = true,
          --       includeInlayVariableTypeHints = true,
          --       includeInlayPropertyDeclarationTypeHints = true,
          --       includeInlayFunctionLikeReturnTypeHints = true,
          --       includeInlayEnumMemberValueHints = true,
          --     },
          --   },
          -- },
        -- },
        html = {
          filetypes = { "html", "cshtml", "razor" }, -- Extend filetypes
        },
        powershell_es = { init_options = { enableProfileLoading = false } },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        zls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        require("roslyn").setup({
          args = {
            "--stdio",
            "--logLevel=Information",
            "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
            "--razorSourceGenerator=" .. vim.fs.joinpath(
              vim.fn.stdpath("data") --[[@as string]],
              "mason",
              "packages",
              "roslyn",
              "libexec",
              "Microsoft.CodeAnalysis.Razor.Compiler.dll"
            ),
            "--razorDesignTimePath=" .. vim.fs.joinpath(
              vim.fn.stdpath("data") --[[@as string]],
              "mason",
              "packages",
              "rzls",
              "libexec",
              "Targets",
              "Microsoft.NET.Sdk.Razor.DesignTime.targets"
            ),
          },
          config = {
            handlers = require("rzls.roslyn_handlers"),
            settings = {
              ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = false,
                csharp_enable_inlay_hints_for_implicit_variable_types = false,

                csharp_enable_inlay_hints_for_lambda_parameter_types = false,
                csharp_enable_inlay_hints_for_types = false,
                dotnet_enable_inlay_hints_for_indexer_parameters = false,
                dotnet_enable_inlay_hints_for_literal_parameters = false,
                dotnet_enable_inlay_hints_for_object_creation_parameters = false,
                dotnet_enable_inlay_hints_for_other_parameters = false,
                dotnet_enable_inlay_hints_for_parameters = false,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
              },
              ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = false,
              },
            },
          },
        }),
      },
    }
    return ret
  end,
}
