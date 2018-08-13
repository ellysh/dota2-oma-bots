local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local M = {}

---------------------------------

function M.pre_kill_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and algorithms.IsUnitLowHp(env.ENEMY_HERO_DATA)
         and not algorithms.IsUnitLowHp(env.BOT_DATA)
         and not env.DOES_TOWER_PROTECT_ENEMY
         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot(env.BOT_DATA, "tower_tier_1_rear"))
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
  algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_HERO_DATA, true)
end

function M.stop_attack()
  if not algorithms.IsUnitAttack(env.BOT_DATA)
     or not algorithms.IsAttackDone(env.BOT_DATA) then
    return end

  env.BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_move_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and not env.DOES_TOWER_PROTECT_ENEMY
         and not algorithms.IsUnitMoving(env.BOT_DATA)
end

function M.post_move_enemy_hero()
  return not M.pre_move_enemy_hero()
end

function M.move_enemy_hero()
  env.BOT:Action_MoveToLocation(env.ENEMY_HERO_DATA.location)
end

---------------------------------

function M.pre_use_silence()
  local ability = env.BOT:GetAbilityByName("drow_ranger_wave_of_silence")

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
  local ability = env.BOT:GetAbilityByName("drow_ranger_wave_of_silence")

  env.BOT:Action_UseAbilityOnLocation(ability, env.ENEMY_HERO_DATA.location)
end

---------------------------------
return M
