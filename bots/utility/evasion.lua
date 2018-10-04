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

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_evasion()
  return algorithms.IsBotAlive()
end

---------------------------------

local function DoesPowerEnemyHeroPursuit()
  return env.ENEMY_HERO_DATA ~= nil

         and env.IS_BOT_LOW_HP

         and algorithms.IsTargetInAttackRange(
               env.ENEMY_HERO_DATA,
               env.BOT_DATA,
               true)
end

function M.pre_use_silence()
  return moves.pre_use_silence()
         and DoesPowerEnemyHeroPursuit()
end

function M.use_silence()
  moves.use_silence()
end

---------------------------------

function M.pre_move_safe_recovery()
  return (env.BOT_DATA.is_flask_healing
          and env.BOT_DATA.health ~= env.BOT_DATA.max_health)

         and not map.IsUnitInSpot(env.BOT_DATA, env.SAFE_SPOT)

         and not algorithms.HasModifier(
                   env.BOT_DATA,
                   "modifier_fountain_aura_buff")
end

function M.move_safe_recovery()
  env.BOT:Action_MoveDirectly(env.SAFE_SPOT)

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------

function M.pre_move_safe_evasion()
  return env.IS_FOCUSED_BY_CREEPS

         or env.IS_BOT_LOW_HP

         or DoesPowerEnemyHeroPursuit()

         or env.IS_FOCUSED_BY_TOWER

         or (env.IS_FOCUSED_BY_ENEMY_HERO
             and algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   constants.CREEP_MAX_AGRO_RADIUS))

         or env.IS_FOCUSED_BY_UNKNOWN_UNIT

         or (map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
             and not algorithms.HasLevelForAggression(env.BOT_DATA))
end

function M.move_safe_evasion()
  env.BOT:Action_MoveDirectly(env.SAFE_SPOT)
end

-- Provide an access to local functions for unit tests only

return M
