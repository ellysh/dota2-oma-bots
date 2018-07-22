local map = require(
  GetScriptDirectory() .."/utility/map")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local M = {}

---------------------------------

function M.pre_upgrade_skills()
  local bot_data = common_algorithms.GetBotData()

  return 0 < bot_data.ability_points
end

function M.post_upgrade_skills()
  return not M.pre_upgrade_skills()
end

function M.pre_upgrade()
  return M.pre_upgrade_skills()
end

function M.post_upgrade()
  return not M.pre_upgrade()
end

function M.upgrade()
  -- TODO: Implement this method
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
