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
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()
         and env.BOT_DATA.attack_target ~= env.ENEMY_HERO_DATA
         and env.ALLY_CREEP_FRONT_DATA ~= nil
         and env.ENEMY_CREEP_BACK_DATA == nil

         and not map.IsUnitInSpot(
                   env.ENEMY_HERO_DATA,
                   map.GetEnemySpot("tower_tier_1_rear_deep"))

         and (not algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   constants.CREEP_MAX_AGGRO_RADIUS)
              or functions.GetDelta(env.LAST_AGGRO_CONTROL, GameTime())
                 < constants.CREEPS_AGGRO_COOLDOWN)
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.pre_attack_enemy_tower()
  return env.ENEMY_TOWER_DATA ~= nil
         and env.ALLY_CREEP_FRONT_DATA ~= nil
         and algorithms.HasLevelForAggression(env.BOT_DATA)
         and algorithms.DoesEnemyTowerAttackAllyCreep(
               env.BOT_DATA,
               env.ENEMY_TOWER_DATA)

         and not env.IS_FOCUSED_BY_TOWER

         and (env.ENEMY_HERO_DATA == nil

              or (constants.MIN_HERO_DISTANCE < env.ENEMY_HERO_DISTANCE

                  and constants.UNIT_HALF_HEALTH_LEVEL
                      <= functions.GetRate(
                           env.BOT_DATA.health,
                           env.BOT_DATA.max_health)))
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

function M.move_safe()
  env.BOT:Action_MoveDirectly(env.FARM_SPOT)

  action_timing.SetNextActionDelay(0.4)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
