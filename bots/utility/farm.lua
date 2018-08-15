local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_farm()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep())
end

function M.post_farm()
  return not M.pre_farm()
end

---------------------------------

local function IsLastHit(bot_data, unit_data)
  local incoming_damage = bot_data.attack_damage
                          + algorithms.GetTotalDamageToUnit(
                              unit_data,
                              functions.GetUnitDistance(
                                bot_data,
                                unit_data))

  if (100 < bot_data.attack_damage or 2 < unit_data.armor) then
    incoming_damage = incoming_damage
                      * functions.GetDamageMultiplier(unit_data.armor)
  end

  return unit_data.health < incoming_damage
end

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
             and IsLastHit(env.BOT_DATA, unit_data)
    end)
end

function M.pre_lasthit_enemy_creep()
  return GetLastHitCreep(constants.SIDE["ENEMY"]) ~= nil
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
  local target_data = GetLastHitCreep(constants.SIDE["ALLY"])

  return target_data ~= nil
         and functions.GetRate(target_data.health, target_data.max_health)
             < constants.UNIT_HALF_HEALTH_LEVEL
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