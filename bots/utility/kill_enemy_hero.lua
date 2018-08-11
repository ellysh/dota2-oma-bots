local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_kill_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and common_algorithms.IsUnitLowHp(env.ENEMY_HERO_DATA)
         and env.ENEMY_HERO_DATA.health < env.BOT_DATA.health
         and not env.DOES_TOWER_PROTECT_ENEMY
end

function M.post_kill_enemy_hero()
  return not M.pre_kill_enemy_hero()
end

---------------------------------

function M.pre_attack_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and not env.DOES_TOWER_PROTECT_ENEMY
         and functions.GetUnitDistance(env.BOT_DATA, env.ENEMY_HERO_DATA)
             <= env.BOT_DATA.attack_range
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  common_algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_HERO_DATA, true)
end

function M.stop_attack()
  if not common_algorithms.IsUnitAttack(env.BOT_DATA)
     or not common_algorithms.IsAttackDone(env.BOT_DATA) then
    return end

  local bot = GetBot()
  bot:Action_ClearActions(true)
end

---------------------------------

function M.pre_move_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and not env.DOES_TOWER_PROTECT_ENEMY
         and not common_algorithms.IsUnitMoving(env.BOT_DATA)
end

function M.post_move_enemy_hero()
  return not M.pre_move_enemy_hero()
end

function M.move_enemy_hero()
  local bot = GetBot()

  bot:Action_MoveToLocation(env.ENEMY_HERO_DATA.location)
end

---------------------------------

function M.pre_use_silence()
  local bot = GetBot()
  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  return env.ENEMY_HERO_DATA ~= nil
         and not env.ENEMY_HERO_DATA.is_silenced
         and not env.BOT_DATA.is_silenced
         and ability:IsFullyCastable()
         and functions.GetUnitDistance(env.BOT_DATA, env.ENEMY_HERO_DATA)
               <= ability:GetCastRange()
         and not env.DOES_TOWER_PROTECT_ENEMY
end

function M.post_use_silence()
  return not M.pre_use_silence()
end

function M.use_silence()
  local bot = GetBot()
  local ability = bot:GetAbilityByName("drow_ranger_wave_of_silence")

  bot:Action_UseAbilityOnLocation(ability, env.ENEMY_HERO_DATA.location)
end

---------------------------------
return M
