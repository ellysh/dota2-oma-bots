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
         and (M.pre_move_and_block()
              or M.pre_move_start_position())
end

function M.post_body_block()
  return not M.pre_body_block()
end

---------------------------------

local function GetBodyBlockSpot()
  return functions.ternary(
           DotaTime() < 20,
           map.GetAllySpot(env.BOT_DATA, "first_body_block"),
           map.GetAllySpot(env.BOT_DATA, "tower_tier_1_attack"))
end

function M.pre_move_start_position()
  return not algorithms.AreAllyCreepsInRadius(
               env.BOT_DATA,
               constants.MAX_UNIT_SEARCH_RADIUS)
         and not algorithms.AreEnemyCreepsInRadius(
               env.BOT_DATA,
               constants.MAX_UNIT_SEARCH_RADIUS)
         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   GetBodyBlockSpot())
end

function M.post_move_start_position()
  return not M.pre_move_start_position()
end

function M.move_start_position()
  env.BOT:Action_MoveToLocation(
    map.GetAllySpot(env.BOT_DATA, GetBodyBlockSpot()))

  action_timing.SetNextActionDelay(1)
end

---------------------------------

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
  return algorithms.AreAllyCreepsInRadius(
           env.BOT_DATA,
           constants.MAX_MELEE_ATTACK_RANGE)
         and not algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   constants.MAX_CREEP_DISTANCE)
end

function M.post_move_and_block()
  return not M.pre_move_and_block()
end

function M.move_and_block()
  local creep = all_units.GetUnit(GetFirstMovingCreep())
  local target_location = creep:GetExtrapolatedLocation(2)

  env.BOT:Action_MoveToLocation(target_location)

  local distance = functions.GetDistance(
                     env.BOT_DATA.location,
                     target_location)

  action_timing.SetNextActionDelay(distance/env.BOT_DATA.speed)
end

function M.stop_attack_and_move()
  local creep_data = GetFirstMovingCreep()
  local distance = functions.GetDistance(
                     env.BOT_DATA.location,
                     creep_data.location)

  env.BOT:Action_ClearActions(true)

  action_timing.SetNextActionDelay((distance/creep_data.speed) / 2)
end

---------------------------------


-- Provide an access to local functions for unit tests only

return M
