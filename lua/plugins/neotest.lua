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

      -- Patch neotest-dotnet for nvim 0.12, here and in neotest's parsing subprocess.
      local dotnet_patch = vim.fn.stdpath("config") .. "/lua/config/neotest_dotnet.lua"
      dofile(dotnet_patch)
      local subprocess = require("neotest.lib").subprocess
      local subprocess_init = subprocess.init
      subprocess.init = function()
        subprocess_init()
        if subprocess.enabled() then
          subprocess.request("nvim_exec_lua", "dofile(...)", { dotnet_patch })
        end
      end

      -- neotest-dotnet strips theory arguments from the filter, so running one case runs
      -- them all. Narrow it with DisplayName conditions built from the argument text;
      -- quotes, commas etc. can't survive dotnet/msbuild, so match the pieces between them.
      local function dotnet_case_filter(position, command)
        local params = position.type == "test" and position.name:match("%b()")
        local prefix = '--filter FullyQualifiedName~"'
        local start, fqn_start = command:find(prefix, 1, true)
        local fqn_end = fqn_start and command:find('"', fqn_start + 1, true)
        if not params or not fqn_end then
          return command
        end
        local conditions = { "FullyQualifiedName~" .. command:sub(fqn_start + 1, fqn_end - 1) }
        for piece in params:sub(2, -2):gmatch("[%w _.:%[%]<>{}/+-]+") do
          piece = vim.trim(piece)
          if piece:find("%w") then
            conditions[#conditions + 1] = "DisplayName~" .. piece
          end
        end
        local filter = "--filter '" .. table.concat(conditions, "&") .. "'"
        return command:sub(1, start - 1) .. filter .. command:sub(fqn_end + 1)
      end

      local function fix_dotnet_specs(adapter)
        local build_spec = adapter.build_spec
        adapter.build_spec = function(args)
          local specs = build_spec(args)
          -- An empty list makes neotest run a spec with no context and crash in results();
          -- nil makes it run the child positions instead.
          if not specs or #specs == 0 then
            return nil
          end
          if #specs == 1 then
            specs[1].command = dotnet_case_filter(args.tree:data(), specs[1].command)
          end
          return specs
        end
        return adapter
      end

      -- Only show tests for the folder we are working in: in a repo with several
      -- language folders (csharp/, go/, ...), an adapter must not pick up a sibling
      -- folder's project or test files opened from outside the cwd.
      local function scope_to_cwd(adapter)
        local root, is_test_file = adapter.root, adapter.is_test_file
        adapter.root = function(dir)
          local found = root(dir)
          return found and vim.fs.relpath(found, dir) and found or nil
        end
        adapter.is_test_file = function(path)
          return vim.fs.relpath(vim.uv.cwd(), path) ~= nil and is_test_file(path)
        end
        return adapter
      end

      local adapters = {
        require("neotest-python")({
          dap = {
            justMyCode = false,
          },
        }),

        require("neotest-plenary"),

        fix_dotnet_specs(require("neotest-dotnet")({
          discovery_root = "project",
        })),

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
      }

      neotest.setup({
        adapters = vim.tbl_map(scope_to_cwd, adapters),
      })
    end,
  },
}
