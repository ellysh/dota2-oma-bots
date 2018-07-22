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

local ENEMY_HERO_DATA = {}
local DOES_TOWER_PROTECT_ENEMY = false

function M.UpdateVariables()
  ENEMY_HERO_DATA = common_algorithms.GetEnemyHero(
                      bot_data,
                      constants.MAX_PURSUE_DISTANCE)

  DOES_TOWER_PROTECT_ENEMY = common_algorithms.DoesTowerProtectEnemyUnit(
                               ENEMY_HERO_DATA)
end

---------------------------------

function M.pre_kill_enemy_hero()
  local bot_data = common_algorithms.GetBotData()

  return ENEMY_HERO_DATA ~= nil
         and common_algorithms.IsUnitLowHp(ENEMY_HERO_DATA)
         and ENEMY_HERO_DATA.health < bot_data.health
         and not recovery.pre_recovery()
         and not DOES_TOWER_PROTECT_ENEMY
end

function M.post_kill_enemy_hero()
  return not M.pre_kill_enemy_hero()
end

---------------------------------

function M.pre_attack_enemy_hero()
  local bot_data = common_algorithms.GetBotData()

  return ENEMY_HERO_DATA ~= nil
         and not DOES_TOWER_PROTECT_ENEMY
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  local bot_data = common_algorithms.GetBotData()

  common_algorithms.AttackUnit(bot_data, ENEMY_HERO_DATA, true)
end

---------------------------------

function M.pre_use_silence()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  return ENEMY_HERO_DATA ~= nil
         and not ENEMY_HERO_DATA.is_silenced
         and ability:IsFullyCastable()
         and functions.GetUnitDistance(bot_data, ENEMY_HERO_DATA)
               <= ability:GetCastRange()
         and not DOES_TOWER_PROTECT_ENEMY
end

function M.post_use_silence()
  return not M.pre_use_silence()
end

function M.use_silence()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()
  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  bot:Action_UseAbilityOnLocation(ability, ENEMY_HERO_DATA.location)
end

---------------------------------
return M
