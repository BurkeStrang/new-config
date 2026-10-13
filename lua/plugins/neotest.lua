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
      "Issafalcon/neotest-dotnet",

      -- Go
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
      },
    },

    config = function()
      local neotest = require("neotest")

      require("dap-go").setup()

      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = {
              justMyCode = false,
            },
          }),

          require("neotest-plenary"),

          require("neotest-dotnet")({
            discovery_root = "solution",
          }),

          require("neotest-jest")({
            jestCommand = "npm test -- --runInBand --no-cache --watchAll=false",
            env = {
              CI = "true",
            },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),

          require("neotest-golang")({
            runner = "go",
          }),
        },
      })
    end,
  },
}
