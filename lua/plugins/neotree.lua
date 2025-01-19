return {
  "neo-tree.nvim",
  opts = {
    filesystem = {
      window = {
        position = "right",
        mappings = {
          ["Y"] = "none",
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    git_status = {
      added = {
        highlight = "NeoTreeGitAdded",
      },
    },
  },
}

