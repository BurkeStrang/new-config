return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local function get_sdk_path()
      -- If you also want to differentiate between Windows/WSL/Linux, you can
      -- check 'require("easy-dotnet.extensions").isWindows()' or 'isWsl()'
      -- For simplicity here, we're just returning the Linux path.
      if require("easy-dotnet.extensions").isWindows() then
        return "C:\\Program Files\\dotnet\\sdk\\9.0.101"
      end
      return "/usr/lib/dotnet/sdk/9.0.101"
    end

    local function get_secret_path(secret_guid)
      local path = ""
      local home_dir = vim.fn.expand("~")
      if require("easy-dotnet.extensions").isWindows() then
        -- Windows path
        path = home_dir .. "\\AppData\\Roaming\\Microsoft\\UserSecrets\\" .. secret_guid .. "\\secrets.json"
      else
        -- Linux/macOS/WSL path
        path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
      end
      return path
    end

    local dotnet = require("easy-dotnet")
    dotnet.setup({
      -- Point to a specific SDK version
      get_sdk_path = get_sdk_path,

      test_runner = {
        viewmode = "float",
        enable_buffer_test_execution = true, -- Experimental
        noBuild = true,
        noRestore = true,
        icons = {
          passed = "",
          skipped = "",
          failed = "",
          success = "",
          reload = "",
          test = "",
          sln = "󰘐",
          project = "󰘐",
          dir = "",
          package = "",
        },
        mappings = {
          -- run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
          -- filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
          -- debug_test = { lhs = "<leader>d", desc = "debug test" },
          -- go_to_file = { lhs = "g", desc = "go to file" },
          -- run_all = { lhs = "<leader>R", desc = "run all tests" },
          -- run = { lhs = "<leader>r", desc = "run test" },
          -- peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
          -- expand = { lhs = "o", desc = "expand" },
          -- expand_node = { lhs = "E", desc = "expand node" },
          -- expand_all = { lhs = "-", desc = "expand all" },
          -- collapse_all = { lhs = "W", desc = "collapse all" },
          -- close = { lhs = "q", desc = "close testrunner" },
          -- refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
        },
        additional_args = {},
      },

      ---@param action "test" | "restore" | "build" | "run"
      terminal = function(path, action, args)
        local commands = {
          run = function()
            return string.format("dotnet run --project %s %s", path, args)
          end,
          test = function()
            return string.format("dotnet test %s %s", path, args)
          end,
          restore = function()
            return string.format("dotnet restore %s %s", path, args)
          end,
          build = function()
            return string.format("dotnet build %s %s", path, args)
          end,
        }
        local command = commands[action]() .. "\r"
        vim.cmd("vsplit")
        vim.cmd("term " .. command)
      end,

      secrets = {
        path = get_secret_path,
      },
      csproj_mappings = true,
      fsproj_mappings = true,
      auto_bootstrap_namespace = true,
    })

    -- Example command
    vim.api.nvim_create_user_command("Secrets", function()
      dotnet.secrets()
    end, {})

    -- Example keybindings
    -- vim.keymap.set("n", "<leader>rp", function()
    --   dotnet.run_project()
    -- end, { desc = "Run .NET project" })
    -- vim.keymap.set("n", "<leader>tb", function()
    --   require("easy-dotnet").run_test_from_buffer()
    -- end, { desc = "Run tests from buffer" })
    -- vim.keymap.set("n", "<leader>db", function()
    --   dotnet.debug_buffer()
    -- end, { desc = "Debug tests in buffer" })
    -- vim.keymap.set("n", "<leader>rf", function()
    --   dotnet.refresh()
    -- end, { desc = "Refresh .NET project" })
  end,
}
