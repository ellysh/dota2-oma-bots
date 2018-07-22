local skill_build = require(
  GetScriptDirectory() .."/database/skill_build")

local map = require(
  GetScriptDirectory() .."/utility/map")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local M = {}

function M.UpdateVariables()
end

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
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:ActionImmediate_LevelAbility(
    skill_build.SKILL_BUILD[bot_data.level])
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
