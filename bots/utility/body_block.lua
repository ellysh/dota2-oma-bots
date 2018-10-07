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
  return algorithms.IsBotAlive()
end

---------------------------------

local function GetBodyBlockSpot()
  return functions.ternary(
           algorithms.IsFirstWave(),
           map.GetAllySpot("first_body_block"),
           map.GetAllySpot("second_body_block"))
end

function M.pre_move_start_position()
  return env.ALLY_CREEP_FRONT_DATA == nil

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   GetBodyBlockSpot())
end

function M.move_start_position()
  env.BOT:Action_MoveDirectly(GetBodyBlockSpot())

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------

function M.pre_turn_enemy_fountain()
  return env.ALLY_CREEP_FRONT_DATA == nil

         and map.IsUnitInSpot(
               env.BOT_DATA,
               GetBodyBlockSpot())

         and not functions.IsFacingLocation(
                   env.BOT_DATA,
                   map.GetEnemySpot("high_ground"),
                   30)

         and not algorithms.IsTargetInAttackRange(
                   env.ENEMY_HERO_DATA,
                   env.BOT_DATA,
                   true)
end

function M.turn_enemy_fountain()
  env.BOT:Action_MoveDirectly(
    map.GetEnemySpot("high_ground"))
end

function M.stop_turn()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

local function CompareMinHgDistance(t, a, b)
  local high_ground_spot = map.GetAllySpot("high_ground")

  return functions.GetDistance(high_ground_spot, t[a].location)
         < functions.GetDistance(high_ground_spot, t[b].location)
end

local function GetFirstMovingCreep()
  local creeps = algorithms.GetAllyCreeps(
                   env.BOT_DATA,
                   constants.MAX_UNIT_TARGET_RADIUS)

  return functions.GetElementWith(
           creeps,
           CompareMinHgDistance)
end

local function IsAllowableFountainDistance()
  local max_distance = functions.ternary(
                         GetTeam() == TEAM_RADIANT,
                         constants.BODY_BLOCK_FOUNTAIN_RADIANT_DISTANCE,
                         constants.BODY_BLOCK_FOUNTAIN_DIRE_DISTANCE)

  return functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)
         <= max_distance
end

function M.pre_move_and_block()
  return algorithms.AreAllyCreepsInRadius(
           env.BOT_DATA,
           constants.MAX_MELEE_ATTACK_RANGE,
           constants.DIRECTION["BACK"])

         and IsAllowableFountainDistance()

         and not algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   env.BOT_DATA.attack_range)

         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)

         and not algorithms.IsTargetInAttackRange(
                   env.ENEMY_HERO_DATA,
                   env.BOT_DATA,
                   true)
end

function M.move_and_block()
  local creep = all_units.GetUnit(GetFirstMovingCreep())
  local target_location = creep:GetExtrapolatedLocation(1.0)

  if algorithms.GetDistanceFromFountain(env.BOT_DATA, target_location)
     < algorithms.GetUnitDistanceFromFountain(env.BOT_DATA) then

     return
  end

  env.BOT:Action_MoveDirectly(target_location)

  local distance = functions.GetDistance(
                     env.BOT_DATA.location,
                     target_location)
                   - env.BOT_DATA.collision_size

  local multiplier = functions.ternary(algorithms.IsFirstWave(), 0.8, 0.7)

  action_timing.SetNextActionDelay(
    (distance/env.BOT_DATA.speed) * multiplier)
end

function M.stop_attack_and_move()
  local creep_data = GetFirstMovingCreep()

  local collision_size = env.BOT_DATA.collision_size
                         + creep_data.collision_size

  local distance = functions.GetDistance(
                     env.BOT_DATA.location,
                     creep_data.location)
                   - collision_size

  env.BOT:Action_ClearActions(true)

  local multiplier = functions.ternary(algorithms.IsFirstWave(), 0.2, 0.35)

  action_timing.SetNextActionDelay(
    (distance/creep_data.speed) * multiplier)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
