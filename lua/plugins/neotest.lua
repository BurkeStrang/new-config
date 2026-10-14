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
      "marilari88/neotest-vitest",
      "Issafalcon/neotest-dotnet",
      -- Rust: adapter ships with rustaceanvim (lazyvim lang.rust extra)
      "mrcjkb/rustaceanvim",

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

      -- rustaceanvim treats every .rs file as a test file, so plain source files fill the
      -- summary. Keep only files with a test attribute (#[test], #[tokio::test], ...).
      -- It also discovers tests by asking rust-analyzer, and neotest scans the project at
      -- startup before rust-analyzer is ready, leaving every file empty for good. Since only
      -- real test files get here, an empty result means "not ready yet": wait and retry.
      local function fix_rust_adapter(adapter)
        local is_test_file, discover_positions = adapter.is_test_file, adapter.discover_positions
        adapter.is_test_file = function(path)
          if not is_test_file(path) then
            return false
          end
          local ok, content = pcall(require("neotest.lib").files.read, path)
          return ok and content:find("#%[[%w_:]*test") ~= nil
        end
        adapter.discover_positions = function(path)
          local tree
          for _ = 1, 60 do
            tree = discover_positions(path)
            for _, node in tree:iter_nodes() do
              if node:data().type == "test" then
                return tree
              end
            end
            require("nio").sleep(3000)
          end
          return tree
        end
        return adapter
      end

      -- neotest-vitest shows a `test.each([...])("$name", ...)` as one test literally named
      -- "$name", while vitest reports results per case ("Example 1", ...), so the run never
      -- matches and stays "running". Replace the template with one test per case, reading
      -- each `$var` from the case objects in the source (literal values only).
      local function expand_vitest_each(adapter)
        local Tree = require("neotest.types").Tree
        local discover_positions = adapter.discover_positions

        local function case_names(template, source)
          local vars, values, count = {}, {}, nil
          for var in template:gmatch("%$([%a_][%w_]*)") do
            values[var] = {}
            for value in source:gmatch("[{,]%s*" .. var .. "%s*:%s*([^,}\n]+)") do
              table.insert(values[var], (vim.trim(value):gsub("^([\"'`])(.*)%1$", "%2")))
            end
            if count and #values[var] ~= count or #values[var] == 0 then
              return nil
            end
            count = #values[var]
            vars[#vars + 1] = var
          end
          if not count then
            return nil
          end
          local names = {}
          for i = 1, count do
            names[i] = template:gsub("%$([%a_][%w_]*)", function(var)
              return values[var] and values[var][i]
            end)
          end
          return names
        end

        local function expand(list, lines, parent_id)
          local expanded = { list[1] }
          for i = 2, #list do
            local child = list[i]
            local data = child[1]
            local names = data.type == "test"
              and data.name:find("$", 1, true)
              and case_names(data.name, table.concat(lines, "\n", data.range[1] + 1, data.range[3] + 1))
            if names then
              for _, name in ipairs(names) do
                local case = vim.tbl_extend("force", data, { id = parent_id .. "::" .. name, name = name })
                table.insert(expanded, { case })
              end
            else
              table.insert(expanded, expand(child, lines, data.id))
            end
          end
          return expanded
        end

        -- vitest reports the cases a run filtered out as "skipped"; keep only results for
        -- what was actually run, so running one case doesn't wipe its siblings' status.
        local build_spec, results = adapter.build_spec, adapter.results
        local function only_run(run_tree, all)
          local kept = {}
          for _, node in run_tree:iter_nodes() do
            local id = node:data().id
            kept[id] = (all or {})[id]
          end
          return kept
        end
        adapter.build_spec = function(args)
          local spec = build_spec(args)
          local stream = spec and spec.stream
          if stream then
            spec.stream = function(...)
              local next_results = stream(...)
              return function()
                return only_run(args.tree, next_results())
              end
            end
          end
          return spec
        end
        adapter.results = function(spec, result, tree)
          return only_run(tree, results(spec, result, tree))
        end

        adapter.discover_positions = function(path)
          local tree = discover_positions(path)
          if not tree then
            return tree
          end
          local lines = vim.split(require("neotest.lib").files.read(path), "\n")
          local list = expand(tree:to_list(), lines, tree:data().id)
          return Tree.from_list(list, function(pos)
            return pos.id
          end)
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
          -- list each @pytest.mark.parametrize case (e.g. "Example 1") as its own test
          pytest_discover_instances = true,
        }),

        require("neotest-plenary"),

        fix_dotnet_specs(require("neotest-dotnet")({
          discovery_root = "project",
        })),

        expand_vitest_each(require("neotest-vitest")),

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

        fix_rust_adapter(require("rustaceanvim.neotest")),
      }

      neotest.setup({
        adapters = vim.tbl_map(scope_to_cwd, adapters),
      })
    end,
  },
}
