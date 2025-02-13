return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    {
      "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
      opts = {},
    },
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "openai",
        },
        inline = {
          adapter = "openai",
        },
        agent = {
          adapter = "openai",
        },
      },
    })

    -- Add the keyboard shortcut
    vim.api.nvim_set_keymap("n", "<leader>ac", ":CodeCompanionChat<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "<leader>cca", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("v", "<leader>cca", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    --
    -- -- Expand 'cc' into 'CodeCompanion' in the command line
    -- vim.cmd([[cab cc CodeCompanion]])
  end,
}
