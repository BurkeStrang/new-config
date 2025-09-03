return {
  "neo-tree.nvim",
  opts = {
    window = {
      position = "right", -- Global window position for all sources
    },
    filesystem = {
      window = {
        position = "right", -- Specific to filesystem
        mappings = {
          ["Y"] = "none",
          ["D"] = "diff_with_current",
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      commands = {
        diff_with_current = function(state)
          local node = state.tree:get_node()
          if node and node.path then
            local current_win = vim.api.nvim_get_current_win()
            vim.cmd("wincmd p")                       -- Switch to the previous window
            vim.cmd("vert diffsplit " .. vim.fn.fnameescape(node.path))
            vim.api.nvim_set_current_win(current_win) -- Return to Neo-tree window
          else
            vim.notify("No file selected", vim.log.levels.WARN)
          end
        end,
      },
    },
    buffers = {
      window = {
        position = "right"
      },
    },
    git_status = {
      window = {
        position = "right" },
    },
  },
}
