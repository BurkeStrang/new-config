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
      -- window = {
      --   mappings = {
      --     ["p"] = "image_wezterm",
      --   },
      -- },
      -- command = {
      --   image_wezterm = function(state)
      --     local node = state.tree:get_node()
      --     if node.type == "file" then
      --       require("image_preview").PreviewImage(node.path)
      --     end
      --   end,
      -- },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        -- hide_by_name = {
        --   ".github",
        --   ".gitignore",
        --   "package-lock.json",
        -- },
        -- never_show = { ".git" },
      },
    },
  },
}
