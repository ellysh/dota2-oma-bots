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
  return not algorithms.IsUnitLowHp(env.BOT_DATA)

         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep())

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot(env.BOT_DATA, "tower_tier_1_rear"))
end

function M.post_farm()
  return not M.pre_farm()
end

---------------------------------

local function GetLastHitCreep(side)
  local creeps = functions.ternary(
    side == constants.SIDE["ENEMY"],
    algorithms.GetEnemyCreeps(
      env.BOT_DATA,
      constants.MAX_UNIT_TARGET_RADIUS),
    algorithms.GetAllyCreeps(
      env.BOT_DATA,
      constants.MAX_UNIT_TARGET_RADIUS))

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMinHealth,
    function(unit_data)
      return algorithms.IsAttackTargetable(unit_data)
             and algorithms.IsLastHitTarget(env.BOT_DATA, unit_data)
    end)
end

function M.pre_lasthit_enemy_creep()
  local creep = GetLastHitCreep(constants.SIDE["ENEMY"])

  return creep ~= nil
         and not algorithms.DoesTowerProtectEnemyUnit(creep)
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local creep = GetLastHitCreep(constants.SIDE["ENEMY"])

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

---------------------------------

function M.pre_deny_ally_creep()
  local creep = GetLastHitCreep(constants.SIDE["ALLY"])

  return creep ~= nil
         and functions.GetRate(creep.health, creep.max_health)
             < constants.UNIT_HALF_HEALTH_LEVEL
         and not algorithms.DoesTowerProtectEnemyUnit(creep)
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local target_data = GetLastHitCreep(constants.SIDE["ALLY"])

  algorithms.AttackUnit(env.BOT_DATA, target_data, false)
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
