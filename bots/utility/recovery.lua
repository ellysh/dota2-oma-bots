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
         and not bot_data.is_healing
         and bot_data.health < enemy_data.health
end

function M.post_recovery()
  return not M.pre_recovery()
end

---------------------------------

function M.pre_heal_flask()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_flask')
end

function M.post_heal_flask()
  return not M.pre_heal_flask()
end

function M.heal_flask()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbilityOnEntity(
    common_algorithms.GetItem(bot_data, 'item_flask'),
    bot)
end

---------------------------------

function M.pre_heal_tango()
  return false
end

---------------------------------

function M.pre_move_shrine()
  return false
end

---------------------------------

function M.pre_tp_base()
  return false
end

---------------------------------

function M.pre_move_base()
  return false
end

return M
