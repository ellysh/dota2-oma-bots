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

local M = {}

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
         and not common_algorithms.DoesTowerProtectEnemyUnit(target_data)
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
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(
                        bot_data,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  common_algorithms.AttackUnit(bot_data, target_data, true)
end

---------------------------------

function M.pre_use_silence()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(
                        bot_data,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  return target_data ~= nil
         and not target_data.is_silenced
         and ability:IsFullyCastable()
end

function M.post_use_silence()
  return not M.pre_use_silence()
end

function M.use_silence()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()
  local target_data = common_algorithms.GetEnemyHero(
                        bot_data,
                        constants.MAX_UNIT_SEARCH_RADIUS)
  local target = all_units.GetUnit(target_data)

  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  bot:Action_UseAbilityOnEntity(ability, target)
end

---------------------------------
return M
