return {
  "snacks.nvim",
  opts = {
    dashboard = {
      width = 25,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 1, -- empty columns between vertical panes
      preset = {
        keys = {
          {
            icon = " ",
            key = "f",
            desc = " Find File      ",
            action = ":lua Snacks.dashboard.pick('files')",
          },
          { icon = " ", key = "n", desc = " New File       ", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "g",
            desc = " Find Text      ",
            action = ":lua Snacks.dashboard.pick('live_grep')",
          },
          {
            icon = " ",
            key = "r",
            desc = " Recent Files   ",
            action = ":lua Snacks.dashboard.pick('oldfiles')",
          },
          -- {
          --   icon = " ",
          --   key = "d",
          --   desc = " Recent Files   ",
          --   action = ":lua Snacks.dashboard.pick('oldfiles','true')",
          -- },
          {
            icon = " ",
            key = "c",
            desc = " Config         ",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = " Restore Session", section = "session" },
          { icon = " ", key = "x", desc = " Lazy Extras    ", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = " Lazy           ", action = ":Lazy" },
          { icon = " ", key = "q", desc = " Quit           ", action = ":qa" },
        },
        header = [[

Programming is the art of telling another human

being what one wants the computer to do

~ Donald Knuth

        ]],
      },
      formats = {
        header = { "%s", align = "center" },
        footer = { "%s", align = "center" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
        keys = function(item, ctx)
          -- Create a single line with key and description close together.
          local line = string.format("%s  %s", item.key, item.desc)
          -- Center the line based on the dashboard width.
          local padding = math.max(0, math.floor((ctx.width - #line) / 2))
          if padding > 0 then
            line = string.rep(" ", padding) .. line
          end
          return { { line } }
        end,
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 0, padding = 0 },
        -- { section = "startup" },
      },
    },
  },
}
