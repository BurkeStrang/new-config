local M = {}

local telescope = require("telescope")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local Path = require("plenary.path")
local action_state = require("telescope.actions.state")

-- Paths for user secrets
local user_secrets_path_windows = os.getenv("USERPROFILE")
  and os.getenv("USERPROFILE") .. "\\AppData\\Roaming\\Microsoft\\UserSecrets"
local user_secrets_path_wsl = os.getenv("HOME") and os.getenv("HOME") .. "/.microsoft/usersecrets" or nil

-- Function to list user secrets
local function list_user_secrets()
  local user_secrets_path

  -- Determine the operating system and set the user_secrets_path accordingly
  if vim.loop.os_uname().sysname == "Windows_NT" then
    user_secrets_path = user_secrets_path_windows
  else
    if user_secrets_path_wsl then
      user_secrets_path = user_secrets_path_wsl
    else
      print("HOME environment variable is not set.")
      return {}
    end
  end

  -- print("Using user secrets path: " .. user_secrets_path) -- Debugging line

  local secret_files = {}
  local path_obj = Path:new(user_secrets_path)

  -- Check if path exists
  if path_obj:exists() and path_obj:is_dir() then
    for _, file in ipairs(vim.fn.readdir(user_secrets_path)) do
      local file_path = Path:new(user_secrets_path, file)
      if file_path:is_dir() then
        table.insert(secret_files, file_path:absolute())
      end
    end
  else
    print("Path does not exist or is not a directory: " .. user_secrets_path)
  end

  return secret_files
end

-- Function to open user secrets using Telescope
function M.open_user_secrets()
  pickers
    .new({}, {
      prompt_title = "Select User Secret",
      finder = finders.new_table({
        results = list_user_secrets(),
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          local secrets_json_path = Path:new(selection.value, "secrets.json"):absolute()
          if Path:new(secrets_json_path):exists() then
            vim.cmd("edit " .. secrets_json_path)
          else
            print("secrets.json file not found in " .. selection.value)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
