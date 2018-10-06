local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local map = require(
  GetScriptDirectory() .."/utility/map")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_aggro_control()
  return algorithms.IsBotAlive()
end

---------------------------------

-- TODO: This function duplicates the positioning.lua one
local function GetPreLastHitCreep()
  return functions.ternary(
          env.PRE_LAST_HIT_ENEMY_CREEP ~= nil,
          env.PRE_LAST_HIT_ENEMY_CREEP,
          env.PRE_LAST_HIT_ALLY_CREEP)
end

function M.pre_aggro_last_hit()
  local last_hit_creep = GetPreLastHitCreep()

  if last_hit_creep == nil then
    return false end

  local creep_distance = functions.GetUnitDistance(
                           env.BOT_DATA,
                           last_hit_creep)

  return env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_HERO_DATA.is_visible

         and constants.CREEPS_AGGRO_COOLDOWN
             <= functions.GetDelta(env.LAST_AGGRO_CONTROL, GameTime())

         and (env.ENEMY_TOWER_DATA == nil
              or constants.TOWER_AGGRO_RADIUS < env.ENEMY_TOWER_DISTANCE)

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetAllySpot("tower_tier_1_attack"))

         and not algorithms.IsUnitMoving(last_hit_creep)

         and (creep_distance <= constants.CREEP_MAX_AGGRO_RADIUS
              and constants.CREEP_MIN_AGGRO_RADIUS < creep_distance)
end

function M.aggro_last_hit()
  env.BOT:Action_AttackUnit(all_units.GetUnit(env.ENEMY_HERO_DATA), true)

  env.LAST_AGGRO_CONTROL = GameTime()
end

---------------------------------

function M.pre_aggro_hg()
  return env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_CREEP_FRONT_DATA ~= nil
         and env.ENEMY_CREEP_BACK_DATA == nil
         and env.ENEMY_HERO_DATA.is_visible

         and constants.CREEPS_AGGRO_COOLDOWN
             <= functions.GetDelta(env.LAST_AGGRO_CONTROL, GameTime())

         and map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot("river"))

         and functions.GetUnitDistance(
               env.BOT_DATA,
               env.ENEMY_CREEP_FRONT_DATA)
             <= constants.CREEP_MAX_AGGRO_RADIUS
end

function M.aggro_hg()
  env.BOT:Action_AttackUnit(all_units.GetUnit(env.ENEMY_HERO_DATA), true)

  env.LAST_AGGRO_CONTROL = GameTime()
end

---------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
