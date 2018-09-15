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
  return 20 < DotaTime()
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

function M.pre_increase_creeps_distance()
  local last_hit_creep = GetPreLastHitCreep()

  return (last_hit_creep == nil
          or (env.ALLY_CREEPS_HP * 3) < env.ENEMY_CREEPS_HP)

         and (env.ENEMY_CREEP_DATA ~= nil
              and functions.GetUnitDistance(
                    env.BOT_DATA,
                    env.ENEMY_CREEP_DATA)
                  < constants.BASE_CREEP_DISTANCE)

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetAllySpot("tower_tier_1_rear_safe"))
end

function M.increase_creeps_distance()
  env.BOT:Action_MoveDirectly(env.SAFE_SPOT)
end

---------------------------------

local function GetClosestCreep()
  return functions.ternary(
          env.ENEMY_CREEP_DATA ~= nil,
          env.ENEMY_CREEP_DATA,
          env.ALLY_CREEP_FRONT_DATA)
end

function M.pre_decrease_creeps_distance()
  local last_hit_creep = GetPreLastHitCreep()

  return ((last_hit_creep ~= nil
           and not map.IsUnitInEnemyTowerAttackRange(last_hit_creep)
           and constants.LASTHIT_CREEP_DISTANCE
               < functions.GetUnitDistance(
                   env.BOT_DATA,
                   last_hit_creep))

          or not (algorithms.AreEnemyCreepsInRadius(
                    env.BOT_DATA,
                    constants.BASE_CREEP_DISTANCE)
                  or algorithms.AreAllyCreepsInRadius(
                       env.BOT_DATA,
                       constants.BASE_CREEP_DISTANCE)))

         and not env.IS_FOCUSED_BY_CREEPS

         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)

         and env.ALLY_CREEP_FRONT_DATA ~= nil
end

function M.decrease_creeps_distance()
  local last_hit_creep = GetPreLastHitCreep()
  local closest_creep = GetClosestCreep()
  local target_data = functions.ternary(
                        last_hit_creep ~= nil,
                        last_hit_creep,
                        closest_creep)

  env.BOT:Action_MoveDirectly(target_data.location)
end

---------------------------------

function M.pre_turn()
  local last_hit_creep = GetPreLastHitCreep()
  local closest_creep = GetClosestCreep()
  local target_data = functions.ternary(
                        last_hit_creep ~= nil,
                        last_hit_creep,
                        closest_creep)

  return target_data ~= nil

         and not functions.IsFacingLocation(
                   env.BOT_DATA,
                   target_data.location,
                   constants.TURN_TARGET_MAX_DEGREE)
         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
end

function M.turn()
  local last_hit_creep = GetPreLastHitCreep()
  local closest_creep = GetClosestCreep()
  local target_data = functions.ternary(
                        last_hit_creep ~= nil,
                        last_hit_creep,
                        closest_creep)

  env.BOT:Action_AttackUnit(all_units.GetUnit(target_data), true)

  action_timing.SetNextActionDelay(constants.DROW_RANGER_TURN_TIME)
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
