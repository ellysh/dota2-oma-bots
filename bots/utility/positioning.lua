local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_positioning()
  return algorithms.IsBotAlive()
         and (not algorithms.IsFirstWave()
              or (env.ALLY_CREEP_BACK_DATA == nil
                  and env.ALLY_CREEP_FRONT_DATA ~= nil))

         and algorithms.IsBotAlive()
end

---------------------------------

function M.pre_tp_mid_tower()
  local target_location = map.GetAllySpot("high_ground")

  return constants.MIN_TP_BASE_RADIUS
           < functions.GetDistance(target_location, env.BOT_DATA.location)

         and algorithms.IsItemCastable(env.BOT_DATA, "item_tpscroll")
         and not env.IS_BASE_RECOVERY
end

function M.tp_mid_tower()
  local item = algorithms.GetItem(env.BOT_DATA, "item_tpscroll")

  env.BOT:Action_UseAbilityOnLocation(
    item,
    map.GetAllySpot("tp_tower_tier_1"))

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

local function GetPreLastHitCreep()
  return functions.ternary(
          env.PRE_LAST_HIT_ENEMY_CREEP ~= nil,
          env.PRE_LAST_HIT_ENEMY_CREEP,
          env.PRE_LAST_HIT_ALLY_CREEP)
end

local function GetBaseCreepDistance()
  return functions.ternary(
          (env.ENEMY_HERO_DATA ~= nil
           and functions.GetUnitDistance(
                 env.BOT_DATA,
                 env.ENEMY_HERO_DATA)
               < constants.SAFE_HERO_DISTANCE)
          or algorithms.HasLevelForAggression(env.BOT_DATA),
          constants.BASE_CREEP_DISTANCE,
          constants.BASE_CREEP_DISTANCE_NO_ENEMY_HERO)
end

function M.pre_increase_creeps_distance()
  local last_hit_creep = GetPreLastHitCreep()

  return last_hit_creep == nil
         and env.ALLY_CREEP_FRONT_DATA ~= nil
         and ((env.ENEMY_HERO_DATA ~= nil
               and algorithms.IsUnitPositionBetter(
                     env.ENEMY_HERO_DATA,
                     env.BOT_DATA))

              or (env.ENEMY_CREEP_FRONT_DATA ~= nil
                  and functions.GetUnitDistance(
                        env.BOT_DATA,
                        env.ENEMY_CREEP_FRONT_DATA)
                      < GetBaseCreepDistance()))
end

function M.increase_creeps_distance()
  env.BOT:Action_MoveDirectly(env.FARM_SPOT)
end

---------------------------------

local function GetClosestCreep()
  return functions.ternary(
          env.ENEMY_CREEP_FRONT_DATA ~= nil,
          env.ENEMY_CREEP_FRONT_DATA,
          env.ALLY_CREEP_FRONT_DATA)
end

function M.pre_decrease_creeps_distance_base()
  local base_creep_distance = GetBaseCreepDistance()

  return not algorithms.AreEnemyCreepsInRadius(
                env.BOT_DATA,
                base_creep_distance)

         and not algorithms.AreAllyCreepsInRadius(
                  env.BOT_DATA,
                  base_creep_distance)

         and not env.IS_FOCUSED_BY_CREEPS

         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)

         and env.ALLY_CREEP_FRONT_DATA ~= nil
end

function M.decrease_creeps_distance_base()
  local target_data = GetClosestCreep()

  env.BOT:Action_MoveDirectly(target_data.location)
end

---------------------------------

function M.pre_decrease_creeps_distance_aggro()
  local last_hit_creep = GetPreLastHitCreep()

  return env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_HERO_DATA.is_visible
         and env.ALLY_CREEP_FRONT_DATA ~= nil
         and last_hit_creep ~= nil

         and constants.LASTHIT_CREEP_DISTANCE
               < functions.GetUnitDistance(
                   env.BOT_DATA,
               last_hit_creep)

         and not env.IS_FOCUSED_BY_CREEPS

         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
end

function M.decrease_creeps_distance_aggro()
  local target_data = GetPreLastHitCreep()

  env.BOT:Action_MoveDirectly(target_data.location)
end

---------------------------------

function M.pre_turn()
  local last_hit_creep = GetPreLastHitCreep()
  local enemy_hero = env.ENEMY_HERO_DATA
  local target_data = functions.ternary(
                        last_hit_creep ~= nil,
                        last_hit_creep,
                        enemy_hero)

  return target_data ~= nil

         and env.ALLY_CREEP_FRONT_DATA ~= nil

         and not functions.IsFacingLocation(
                   env.BOT_DATA,
                   target_data.location,
                   constants.TURN_TARGET_MAX_DEGREE)

         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
end

function M.turn()
  local last_hit_creep = GetPreLastHitCreep()
  local enemy_hero = env.ENEMY_HERO_DATA
  local target_data = functions.ternary(
                        last_hit_creep ~= nil,
                        last_hit_creep,
                        enemy_hero)

  env.BOT:Action_AttackUnit(all_units.GetUnit(target_data), true)

  action_timing.SetNextActionDelay(constants.DROW_RANGER_TURN_TIME)
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
