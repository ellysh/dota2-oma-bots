local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

---------------------------------

function M.pre_push_lane()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and env.ENEMY_HERO_DATA == nil
         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep()
              or M.pre_attack_enemy_creep()
              or M.pre_attack_enemy_tower())
end

function M.post_push_lane()
  return not M.pre_push_lane()
end

---------------------------------

local SIDE = {
  ENEMY = {},
  ALLY = {},
}

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
    side == SIDE["ENEMY"],
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
  return GetLastHitCreep(SIDE["ENEMY"]) ~= nil
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local creep = GetLastHitCreep(SIDE["ENEMY"])

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

---------------------------------

function M.pre_deny_ally_creep()
  local target_data = GetLastHitCreep(SIDE["ALLY"])

  return target_data ~= nil
         and functions.GetRate(target_data.health, target_data.max_health)
             < constants.UNIT_HALF_HEALTH_LEVEL
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local target_data = GetLastHitCreep(SIDE["ALLY"])

  algorithms.AttackUnit(env.BOT_DATA, target_data, false)
end

--------------------------------

local function GetMaxHealthCreep(side)
  local creeps = functions.ternary(
    side == SIDE["ENEMY"],
    algorithms.GetEnemyCreeps(
      env.BOT_DATA,
      env.BOT_DATA.attack_range),
    algorithms.GetAllyCreeps(
      env.BOT_DATA,
      env.BOT_DATA.attack_range))

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMaxHealth,
    function(unit_data)
      return (side == SIDE["ENEMY"])
             or (side == SIDE["ALLY"]
                 and functions.GetRate(
                       unit_data.health,
                       unit_data.max_health)
                     < constants.UNIT_HALF_HEALTH_LEVEL)
    end)
end

function M.pre_attack_enemy_creep()
  local creep = GetMaxHealthCreep(SIDE["ENEMY"])

  return creep ~= nil
         and constants.UNIT_HALF_HEALTH_LEVEL
             < functions.GetRate(creep.health, creep.max_health)
         and not algorithms.IsFocusedByEnemyHero(env.BOT_DATA)
         and not algorithms.IsFocusedByCreeps(env.BOT_DATA)
end

function M.post_attack_enemy_creep()
  return not M.pre_attack_enemy_creep()
end

function M.attack_enemy_creep()
  local creep = GetMaxHealthCreep(SIDE["ENEMY"])

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

--------------------------------

function M.pre_attack_enemy_tower()
  return env.ENEMY_TOWER_DATA ~= nil
         and algorithms.IsFocusedByCreeps(env.ENEMY_TOWER_DATA)
         and not algorithms.IsFocusedByTower(
                   env.BOT_DATA,
                   env.ENEMY_TOWER_DATA)
         and not algorithms.IsFocusedByEnemyHero(env.BOT_DATA)
         and not algorithms.IsFocusedByCreeps(env.BOT_DATA)
end

function M.post_attack_enemy_tower()
  return not M.pre_attack_enemy_tower()
end

function M.attack_enemy_tower()
  algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_TOWER_DATA, false)
end

--------------------------------

function M.stop_attack()
  if not algorithms.IsUnitAttack(env.BOT_DATA)
     or not algorithms.IsAttackDone(env.BOT_DATA) then
    return end

  local bot = GetBot()
  bot:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
