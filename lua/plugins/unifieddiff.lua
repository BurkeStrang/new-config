return {
  "axkirillov/unified.nvim",
  opts = {
    signs = {
      add = "│",
      delete = "│",
      change = "│",
    },
    highlights = {
      add = "DiffAdd",
      delete = "DiffDelete",
      change = "DiffChange",
    },
    line_symbols = {
      add = "+",
      delete = "-",
      change = "~",
    },
    auto_refresh = true,
    file_tree = {
      width = 0.5,
      filename_first = true,
    },
  },
  keys = {
    {
      "<leader>ud",
      "<cmd>Unified<cr>",
      desc = "Unified Diff",
    },
    {
      "<leader>uR",
      "<cmd>Unified reset<cr>",
      desc = "Unified Reset",
    },
    {
      "<leader>ut",
      function()
        require("unified").toggle()
      end,
      desc = "Toggle Unified",
    },
    {
      "]h",
      function()
        require("unified.navigation").next_hunk()
      end,
      desc = "Next Hunk",
    },
    {
      "[h",
      function()
        require("unified.navigation").previous_hunk()
      end,
      desc = "Prev Hunk",
    },
  },
}
