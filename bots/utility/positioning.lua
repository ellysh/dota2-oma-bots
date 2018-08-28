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
         and (M.pre_tp_mid_tower()
              or M.pre_increase_creeps_distance()
              or M.pre_decrease_creeps_distance()
              or M.pre_turn())
end

function M.post_positioning()
  return not M.pre_positioning()
end

---------------------------------

function M.pre_tp_mid_tower()
  local target_location = map.GetAllySpot("high_ground")

  return constants.MIN_TP_BASE_RADIUS
           < functions.GetDistance(target_location, env.BOT_DATA.location)

         and algorithms.IsItemCastable(env.BOT_DATA, "item_tpscroll")
         and not env.IS_BASE_RECOVERY
end

function M.post_tp_mid_tower()
  return not M.pre_tp_mid_tower()
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

local function GetClosestCreep()
  return functions.ternary(
          env.ENEMY_CREEP_DATA ~= nil,
          env.ENEMY_CREEP_DATA,
          env.ALLY_CREEP_FRONT_DATA)
end

function M.pre_increase_creeps_distance()
  local last_hit_creep = GetPreLastHitCreep()
  local closest_creep = GetClosestCreep()

  return (algorithms.AreEnemyCreepsInRadius(
             env.BOT_DATA,
             constants.MIN_CREEP_DISTANCE)

          or last_hit_creep == nil

          or (env.ALLY_CREEPS_HP * 3) < env.ENEMY_CREEPS_HP)

         and (closest_creep ~= nil
              and functions.GetUnitDistance(env.BOT_DATA, closest_creep)
                  < env.BASE_CREEP_DISTANCE)
end

function M.post_increase_creeps_distance()
  return not M.pre_increase_creeps_distance()
end

function M.increase_creeps_distance()
  env.BOT:Action_MoveDirectly(env.SAFE_SPOT)
end

---------------------------------

function M.pre_decrease_creeps_distance()
  local last_hit_creep = GetPreLastHitCreep()

  return (last_hit_creep ~= nil
          and constants.LASTHIT_CREEP_DISTANCE
              < functions.GetUnitDistance(
                  env.BOT_DATA,
                  last_hit_creep))

         and not env.IS_FOCUSED_BY_CREEPS

         and env.ALLY_CREEP_FRONT_DATA ~= nil
end

function M.post_decrease_creeps_distance()
  return not M.pre_decrease_creeps_distance()
end

function M.decrease_creeps_distance()
  local target_data = GetPreLastHitCreep()

  env.BOT:Action_MoveDirectly(target_data.location)
end

---------------------------------

function M.pre_turn()
  local last_hit_creep = GetPreLastHitCreep()

  return (last_hit_creep ~= nil
          and constants.LASTHIT_CREEP_DISTANCE
              < functions.GetUnitDistance(
                  env.BOT_DATA,
                  last_hit_creep))

         and not functions.IsFacingLocation(
                   env.BOT_DATA,
                   last_hit_creep.location,
                   constants.TURN_TARGET_MAX_DEGREE)
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  local last_hit_creep = GetPreLastHitCreep()

  env.BOT:Action_AttackUnit(all_units.GetUnit(last_hit_creep), true)

  action_timing.SetNextActionDelay(constants.DROW_RANGER_TURN_TIME)
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
