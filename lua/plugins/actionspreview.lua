return {
  "aznhe21/actions-preview.nvim",
  config = function()
    require("actions-preview").setup({
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.9,
          height = 0.95,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return math.floor(max_lines * 0.5)
          end,
        },
      },
    })

    vim.keymap.set(
      { "v", "n" },
      "ga",
      require("actions-preview").code_actions,
      { desc = "Preview Action" }
    )
  end,
}
