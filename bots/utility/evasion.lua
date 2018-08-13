local map = require(
  GetScriptDirectory() .."/utility/map")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

---------------------------------

function M.pre_evasion()
  return M.pre_move_safe_evasion()
         or M.pre_move_safe_recovery()
end

function M.post_evasion()
  return not M.pre_evasion()
end

---------------------------------

function M.pre_move_safe_recovery()
  return (env.BOT_DATA.is_flask_healing
          and env.BOT_DATA.health ~= env.BOT_DATA.max_health)

         or (env.BOT_DATA.is_healing
             and functions.GetRate(
                   env.BOT_DATA.health,
                   env.BOT_DATA.max_health)
                 <= 0.5)

         and not map.IsUnitInSpot(env.BOT_DATA, env.SAFE_SPOT)
end

function M.post_move_safe_recovery()
  return not M.pre_move_safe_recovery()
end

function M.move_safe_recovery()
  env.BOT:Action_MoveToLocation(env.SAFE_SPOT)

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------

function M.pre_move_safe_evasion()
  return algorithms.IsFocusedByCreeps(env.BOT_DATA)

         or algorithms.IsFocusedByTower(
              env.BOT_DATA,
              env.ENEMY_TOWER_DATA)

         or (algorithms.IsFocusedByEnemyHero(env.BOT_DATA)
             and algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   constants.CREEP_AGRO_RADIUS))

         or algorithms.IsFocusedByUnknownUnit(env.BOT_DATA)
end

function M.post_move_safe_evasion()
  return not M.pre_move_safe_evasion()
end

function M.move_safe_evasion()
  env.BOT:Action_MoveToLocation(env.SAFE_SPOT)

  action_timing.SetNextActionDelay(0.8)
end

-- Provide an access to local functions for unit tests only

return M
