local M = {}

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local NEXT_ACTION_TIME = 0 -- seconds

function M.SetNextActionDelay(delay)
  NEXT_ACTION_TIME = GameTime() + delay
end

function M.GetNextActionTime()
  return NEXT_ACTION_TIME
end

---------------------------------

function M.pre_kill_enemy_hero()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(
                        bot_data,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  return target_data ~= nil
         and common_algorithms.IsUnitLowHp(target_data)
         and target_data.health < bot_data.health
end

function M.post_kill_enemy_hero()
  return not M.pre_kill_enemy_hero()
end

---------------------------------

-- TODO: Move this function to the common_algorithms because it
-- has the duplicate in the laning.lua module

local function AttackUnit(bot_data, unit_data)
  local bot = GetBot()
  local unit = all_units.GetUnit(unit_data)

  bot:Action_AttackUnit(unit, true)

  local attack_point = constants.DROW_RANGER_ATTACK_POINT / bot_data.attack_speed

  M.SetNextActionDelay(attack_point)
end

function M.pre_attack_enemy_hero()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(
                        bot_data,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  return target_data ~= nil
end

function M.post_attack_enemy_hero()
  return not M.pre_lasthit_enemy_creep()
end

function M.attack_enemy_hero()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(bot_data)

  AttackUnit(bot_data, target_data)
end

---------------------------------

return M
