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

function M.pre_use_silence()
  return moves.pre_use_silence()

         and algorithms.HasModifier(
                   env.BOT_DATA,
                   "modifier_drow_ranger_frost_arrows_slow")

         and env.ENEMY_HERO_DISTANCE <= constants.MIN_HERO_DISTANCE
end

function M.use_silence()
  moves.use_silence()
end

---------------------------------

local function GetFlaskHealingRemainingDuration()
  local modifier = env.BOT:GetModifierByName("modifier_flask_healing")
  return env.BOT:GetModifierRemainingDuration(modifier)
end

function M.pre_move_safe_recovery()
  return (env.BOT_DATA.is_flask_healing
          and 1 < GetFlaskHealingRemainingDuration()
          and constants.FLASK_HEALING_PER_SECOND
              < functions.GetDelta(
                env.BOT_DATA.max_health,
                env.BOT_DATA.health))

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

local function DoesPowerEnemyHeroPursuit()
  return env.ENEMY_HERO_DATA ~= nil

         and env.IS_BOT_LOW_HP

         and algorithms.IsTargetInAttackRange(
               env.ENEMY_HERO_DATA,
               env.BOT_DATA,
               true)
end

function M.pre_move_safe_evasion()
  return env.IS_FOCUSED_BY_CREEPS

         or env.IS_BOT_LOW_HP

         or DoesPowerEnemyHeroPursuit()

         or env.IS_FOCUSED_BY_TOWER

         or (env.IS_FOCUSED_BY_ENEMY_HERO
             and algorithms.AreEnemyCreepsInRadius(
                   env.BOT_DATA,
                   constants.CREEP_MAX_AGGRO_RADIUS))

         or env.IS_FOCUSED_BY_UNKNOWN_UNIT

         or (env.ENEMY_HERO_DATA ~= nil
             and env.ENEMY_HERO_DISTANCE
                 < constants.BASE_HERO_DISTANCE)

         or env.ENEMY_TOWER_DISTANCE < constants.MIN_TOWER_DISTANCE

         or (map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
             and not algorithms.HasLevelForAggression(env.BOT_DATA))
end

function M.move_safe_evasion()
  env.BOT:Action_MoveDirectly(env.SAFE_SPOT)
end

-- Provide an access to local functions for unit tests only

return M
