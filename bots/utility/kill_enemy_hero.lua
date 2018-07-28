local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local M = {}

local BOT_DATA = {}
local ENEMY_HERO_DATA = {}
local DOES_TOWER_PROTECT_ENEMY = false

function M.UpdateVariables()
  BOT_DATA = common_algorithms.GetBotData()

  ENEMY_HERO_DATA = common_algorithms.GetEnemyHero(
                      BOT_DATA,
                      constants.MAX_PURSUE_DISTANCE)

  if ENEMY_HERO_DATA ~= nil then
    DOES_TOWER_PROTECT_ENEMY =
      common_algorithms.DoesTowerProtectEnemyUnit(
        ENEMY_HERO_DATA)
  end
end

---------------------------------

function M.pre_kill_enemy_hero()
  return ENEMY_HERO_DATA ~= nil
         and common_algorithms.IsUnitLowHp(ENEMY_HERO_DATA)
         and ENEMY_HERO_DATA.health < BOT_DATA.health
         and not DOES_TOWER_PROTECT_ENEMY
end

function M.post_kill_enemy_hero()
  return not M.pre_kill_enemy_hero()
end

---------------------------------

function M.pre_attack_enemy_hero()
  return ENEMY_HERO_DATA ~= nil
         and not DOES_TOWER_PROTECT_ENEMY
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  common_algorithms.AttackUnit(BOT_DATA, ENEMY_HERO_DATA, true)
end

---------------------------------

function M.pre_use_silence()
  local bot = GetBot()
  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  return ENEMY_HERO_DATA ~= nil
         and not ENEMY_HERO_DATA.is_silenced
         and not BOT_DATA.is_silenced
         and ability:IsFullyCastable()
         and functions.GetUnitDistance(BOT_DATA, ENEMY_HERO_DATA)
               <= ability:GetCastRange()
         and not DOES_TOWER_PROTECT_ENEMY
end

function M.post_use_silence()
  return not M.pre_use_silence()
end

function M.use_silence()
  local bot = GetBot()
  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  bot:Action_UseAbilityOnLocation(ability, ENEMY_HERO_DATA.location)
end

---------------------------------
return M
