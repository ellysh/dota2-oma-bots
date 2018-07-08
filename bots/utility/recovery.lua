local M = {}

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

---------------------------------

local function IsUnitLowHp(unit_data)
  return unit_data.health <= constants.UNIT_LOW_HEALTH
         or GetUnitHealthLevel(unit_data)
            <= constants.UNIT_LOW_HEALTH_LEVEL
end

function M.pre_recovery()
  local bot_data = common_algorithms.GetBotData()
  local enemy_data = common_algorithms.GetEnemyHero(bot_data)

  return IsUnitLowHp(bot_data)
         and enemy_data ~= nil
         and bot_data.health < enemy_data.health
end

function M.post_recovery()
  return not M.pre_recovery()
end

---------------------------------

return M
