local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_farm()
  return algorithms.IsBotAlive()
         and not algorithms.IsUnitLowHp(env.BOT_DATA)

         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep())

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot("tower_tier_1_rear"))
end

function M.post_farm()
  return not M.pre_farm()
end

---------------------------------

local LAST_HIT_ENEMY_CREEP = nil

function M.pre_lasthit_enemy_creep()
  LAST_HIT_ENEMY_CREEP = algorithms.GetLastHitCreep(
                  env.BOT_DATA,
                  constants.SIDE["ENEMY"])

  return LAST_HIT_ENEMY_CREEP ~= nil
         and not algorithms.DoesTowerProtectUnit(LAST_HIT_ENEMY_CREEP)
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  algorithms.AttackUnit(env.BOT_DATA, LAST_HIT_ENEMY_CREEP, false)
end

---------------------------------

local LAST_HIT_ALLY_CREEP = nil

function M.pre_deny_ally_creep()
  LAST_HIT_ALLY_CREEP = algorithms.GetLastHitCreep(
                  env.BOT_DATA,
                  constants.SIDE["ALLY"])

  return LAST_HIT_ALLY_CREEP ~= nil
         and functions.GetRate(
               LAST_HIT_ALLY_CREEP.health,
               LAST_HIT_ALLY_CREEP.max_health)
             < constants.UNIT_HALF_HEALTH_LEVEL
         and not algorithms.DoesTowerProtectUnit(LAST_HIT_ALLY_CREEP)
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  algorithms.AttackUnit(env.BOT_DATA, LAST_HIT_ALLY_CREEP, false)
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
