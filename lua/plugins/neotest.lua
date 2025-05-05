return {
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-go",
      "Issafalcon/neotest-dotnet",
      -- { dir = "~/repos/neotest-dotnet" },
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        -- log_level = vim.log.levels.DEBUG,
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-plenary"),
          require("neotest-dotnet")({
            discovery_root = "solution",
          }),
          require("neotest-jest")({
            jestCommand = "npm test -- --runInBand --no-cache --watchAll=false",
            env = { CI = "true" },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-v" },
          }),
        },
      })
    end,
  },
}
