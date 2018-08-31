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
         and (M.pre_move_and_block()
              or M.pre_move_start_position()
              or M.pre_turn_enemy_fountain())
end

function M.post_body_block()
  return not M.pre_body_block()
end

---------------------------------

local function GetBodyBlockSpot()
  return functions.ternary(
           DotaTime() < 20,
           map.GetAllySpot("first_body_block"),
           map.GetAllySpot("second_body_block"))
end

function M.pre_move_start_position()
  return not algorithms.AreAllyCreepsInRadius(
               env.BOT_DATA,
               constants.MAX_UNIT_SEARCH_RADIUS,
               constants.DIRECTION["FRONT"])

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   GetBodyBlockSpot())

         and (env.ENEMY_HERO_DATA == nil
              or env.BOT_DATA.attack_range < env.ENEMY_HERO_DISTANCE)
end

function M.post_move_start_position()
  return not M.pre_move_start_position()
end

function M.move_start_position()
  env.BOT:Action_MoveDirectly(GetBodyBlockSpot())

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------

function M.pre_turn_enemy_fountain()
  return not algorithms.AreAllyCreepsInRadius(
               env.BOT_DATA,
               constants.MAX_UNIT_SEARCH_RADIUS,
               constants.DIRECTION["FRONT"])

         and map.IsUnitInSpot(
               env.BOT_DATA,
               GetBodyBlockSpot())

         and not functions.IsFacingLocation(
                   env.BOT_DATA,
                   map.GetEnemySpot("high_ground"),
                   30)

         and (env.ENEMY_HERO_DATA == nil
              or constants.MAX_HERO_ATTACK_RANGE
                 < env.ENEMY_HERO_DISTANCE)
end

function M.post_turn_enemy_fountain()
  return not M.pre_turn_enemy_fountain()
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

function M.pre_move_and_block()
  local creep_distance = 0

  if env.ALLY_CREEP_BACK_DATA ~= nil then
    creep_distance = functions.GetUnitDistance(
                       env.BOT_DATA,
                       env.ALLY_CREEP_BACK_DATA)
  end

  return algorithms.AreAllyCreepsInRadius(
           env.BOT_DATA,
           constants.MAX_MELEE_ATTACK_RANGE,
           constants.DIRECTION["BACK"])

         and not algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   env.BOT_DATA.attack_range + creep_distance)

         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)

         and (env.ENEMY_HERO_DATA == nil
              or env.BOT_DATA.attack_range + creep_distance
                 < env.ENEMY_HERO_DISTANCE)
end

function M.post_move_and_block()
  return not M.pre_move_and_block()
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
                   - (env.BOT_DATA.collision_size / 2)

  local multiplier = functions.ternary(DotaTime() < 20, 0.8, 0.6)

  action_timing.SetNextActionDelay((distance/env.BOT_DATA.speed) * 0.8)
end

function M.stop_attack_and_move()
  local creep_data = GetFirstMovingCreep()

  local collision_size = (env.BOT_DATA.collision_size
                          + creep_data.collision_size)
                         / 2

  local distance = functions.GetDistance(
                     env.BOT_DATA.location,
                     creep_data.location)
                   - collision_size

  env.BOT:Action_ClearActions(true)

  local multiplier = functions.ternary(DotaTime() < 20, 0.2, 0.3)

  action_timing.SetNextActionDelay(
    (distance/creep_data.speed) * multiplier)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
