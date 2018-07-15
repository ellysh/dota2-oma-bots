local M = {}

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local recovery = require(
  GetScriptDirectory() .."/utility/recovery")

---------------------------------

function M.pre_kill_enemy_hero()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(
                        bot_data,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  return target_data ~= nil
         and common_algorithms.IsUnitLowHp(target_data)
         and target_data.health < bot_data.health
         and not recovery.pre_recovery()
end

function M.post_kill_enemy_hero()
  return not M.pre_kill_enemy_hero()
end

---------------------------------

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

  common_algorithms.AttackUnit(bot_data, target_data)
end

---------------------------------

return M
