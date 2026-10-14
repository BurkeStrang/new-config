-- Loaded both by the neotest config and, via dofile, by neotest's parsing subprocess
-- (which starts with `-u NONE` and so never sees this config).

-- neotest-dotnet calls iter_matches with `all = false`, which nvim 0.12 removed:
-- captures are now lists of nodes, so its framework detection crashes.
local dotnet_discovery = require("neotest-dotnet.framework-discovery")
dotnet_discovery.get_test_framework_utils_from_source = function(source, custom_attribute_args)
  local frameworks = { "xunit", "nunit", "mstest" }
  local attributes = {}
  for _, framework in ipairs(frameworks) do
    attributes[framework] = dotnet_discovery.attribute_match_list(custom_attribute_args, framework)
  end

  require("neotest.async").scheduler()
  local root = vim.treesitter.get_string_parser(source, "c_sharp"):parse()[1]:root()
  local query = vim.treesitter.query.parse("c_sharp", "(attribute name: [(identifier) (qualified_name)] @name)")
  for _, node in query:iter_captures(root, source) do
    local name = vim.treesitter.get_node_text(node, source)
    for _, framework in ipairs(frameworks) do
      if attributes[framework]:find('"' .. name .. '"', 1, true) then
        return require("neotest-dotnet." .. framework)
      end
    end
    if name:find("SkippableFactAttribute$") then
      return require("neotest-dotnet.xunit")
    elseif name:find("TestMethodAttribute$") then
      return require("neotest-dotnet.mstest")
    elseif name:find("TestAttribute$") then
      return require("neotest-dotnet.nunit")
    end
  end
end

-- neotest-dotnet lists the project's tests with `dotnet test -t` for every test file it
-- discovers; its cache goes through vim.g, which copies tables, so it never hits. Share
-- one listing per project, and reuse it briefly so a whole-project scan costs one call.
local nio = require("nio")
local listings = {}
local listing_ttl_ms = 10000

require("neotest-dotnet.utils.dotnet-utils").get_test_full_names = function(project_path)
  local listing = listings[project_path]
  if not listing or (listing.finished_at and vim.uv.now() - listing.finished_at > listing_ttl_ms) then
    listing = { future = nio.control.future(), output = {} }
    listings[project_path] = listing

    local function finish(code)
      listing.result_code = code
      listing.finished_at = vim.uv.now()
      listing.future.set()
    end
    local command = { "dotnet", "test", "-t", project_path, "--", "NUnit.DisplayName=FullName" }
    local ok = pcall(nio.fn.jobstart, command, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        local started = false
        for _, line in ipairs(data) do
          if started then
            table.insert(listing.output, vim.trim(line))
          end
          started = started or line:find("The following Tests are available", 1, true) ~= nil
        end
      end,
      on_exit = function(_, code)
        finish(code)
      end,
    })
    if not ok then
      finish(1)
    end
  end

  return {
    is_complete = function()
      return listing.result_code ~= nil
    end,
    result = function()
      listing.future.wait()
      return { result_code = listing.result_code, output = listing.output }
    end,
  }
end
