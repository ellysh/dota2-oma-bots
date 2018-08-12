local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local map = require(
  GetScriptDirectory() .."/utility/map")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_body_block()
  return 0 < DotaTime()
         and DotaTime() < 20
         and M.pre_move_and_block()
end

function M.post_body_block()
  return not M.pre_body_block()
end

---------------------------------

local function AreAllyCreepsInRadius(radius)
  return algorithms.AreUnitsInRadius(
    env.BOT_DATA,
    radius,
    algorithms.GetAllyCreeps)
end

local function AreEnemyCreepsInRadius(radius)
  return algorithms.AreUnitsInRadius(
    env.BOT_DATA,
    radius,
    algorithms.GetEnemyCreeps)
end

local function CompareMinHgDistance(t, a, b)
  local high_ground_spot = map.GetAllySpot(env.BOT_DATA, "high_ground")

  return functions.GetDistance(high_ground_spot, t[a].location)
         < functions.GetDistance(high_ground_spot, t[b].location)
end

local function GetFirstMovingCreep()
  local creeps = algorithms.GetAllyCreeps(
                   env.BOT_DATA,
                   constants.MAX_UNIT_SEARCH_RADIUS)

  return functions.GetElementWith(
           creeps,
           CompareMinHgDistance)
end

function M.pre_move_and_block()
  return AreAllyCreepsInRadius(constants.MAX_MELEE_ATTACK_RANGE)
         and not AreEnemyCreepsInRadius(constants.MAX_CREEP_DISTANCE)
end

function M.post_move_and_block()
  return not M.pre_move_and_block()
end

function M.move_and_block()
  local unit = all_units.GetUnit(GetFirstMovingCreep())
  local target_location = unit:GetExtrapolatedLocation(2)

  env.BOT:Action_MoveToLocation(target_location)

  local distance = functions.GetDistance(
                     env.BOT_DATA.location,
                     target_location)

  action_timing.SetNextActionDelay(distance/env.BOT_DATA.speed)
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)

  action_timing.SetNextActionDelay(0.2)
end

---------------------------------


-- Provide an access to local functions for unit tests only

return M
