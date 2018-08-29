local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_aggro_control()
  return algorithms.IsBotAlive()
         and M.pre_aggro_last_hit()
end

function M.post_aggro_control()
  return not M.pre_aggro_control()
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

  return last_hit_creep ~= nil

         and env.ENEMY_HERO_DATA ~= nil

         and not algorithms.IsUnitMoving(last_hit_creep)

         and functions.GetUnitDistance(
               env.BOT_DATA,
               last_hit_creep)
             <= constants.CREEP_AGRO_RADIUS
end

function M.post_aggro_last_hit()
  return not M.pre_aggro_last_hit()
end

function M.aggro_last_hit()
  local last_hit_creep = GetPreLastHitCreep()

  env.BOT:Action_AttackUnit(all_units.GetUnit(env.ENEMY_HERO_DATA), true)

  action_timing.SetNextActionDelay(0.05)
end

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
