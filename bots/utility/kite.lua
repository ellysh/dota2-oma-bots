local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local map = require(
  GetScriptDirectory() .."/utility/map")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

---------------------------------

function M.pre_kite()
  return algorithms.IsBotAlive()
         and not env.IS_BOT_LOW_HP

         and (M.pre_attack_enemy_hero()
              or M.pre_move_safe()
              or M.pre_attack_enemy_tower())

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot("tower_tier_1_rear"))
end

function M.post_kite()
  return not M.pre_kite()
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero_safe()
         and not env.IS_FOCUSED_BY_CREEPS
         and not env.IS_FOCUSED_BY_TOWER
         and env.BOT_DATA.attack_target ~= env.ENEMY_HERO_DATA
         and env.PRE_LAST_HIT_ENEMY_CREEP == nil
         and env.PRE_LAST_HIT_ALLY_CREEP == nil
         and not algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   constants.CREEP_AGRO_RADIUS)
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.pre_attack_enemy_tower()
  return env.ENEMY_TOWER_DATA ~= nil
         and 6 <= env.BOT_DATA.level
         and algorithms.DoesEnemyTowerAttackAllyCreep(
               env.BOT_DATA,
               env.ENEMY_TOWER_DATA)

         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_CREEPS
         and not env.IS_FOCUSED_BY_TOWER

         and (env.ENEMY_HERO_DATA == nil
              or (algorithms.GetAttackRange(
                    env.ENEMY_HERO_DATA,
                    env.BOT_DATA,
                    false)
                  < env.ENEMY_HERO_DISTANCE)
              or constants.UNIT_HALF_HEALTH_LEVEL
                 <= functions.GetRate(
                      env.BOT_DATA.health,
                      env.BOT_DATA.max_health))
end

function M.post_attack_enemy_tower()
  return not M.pre_attack_enemy_tower()
end

function M.attack_enemy_tower()
  algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_TOWER_DATA, false)
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

function M.pre_move_safe()
  return env.ENEMY_HERO_DATA ~= nil
         and env.BOT_DATA.attack_target == env.ENEMY_HERO_DATA
         and not algorithms.IsUnitMoving(env.BOT_DATA)
end

function M.post_move_safe()
  return not M.pre_move_safe()
end

function M.move_safe()
  env.BOT:Action_MoveDirectly(env.SAFE_SPOT)

  action_timing.SetNextActionDelay(0.4)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
