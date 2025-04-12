return {
  -- Add Telescope and its dependencies
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- Add a keymap to browse user secret files
      {
        "<leader>gu",
        function()
          require("custom.usersecrets").open_user_secrets()
        end,
        desc = "Select User Secret",
      },
    },
    -- Ensure Telescope is loaded
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,
        },
      })
    end,
  },

  -- Add Telescope FZF Native extension
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
