local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local BOT_DATA = {}
local ENEMY_CREEP_DATA = {}
local ENEMY_HERO_DATA = {}
local ALLY_CREEP_DATA = {}
local ENEMY_TOWER_DATA = {}
local ALLY_CREEPS_HP = 0
local ENEMY_CREEPS_HP = 0

local function GetClosestCreep(radius, get_function)
  local creeps = get_function(
    BOT_DATA,
    radius)

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinDistance,
    function(unit_data)
      return not common_algorithms.IsUnitLowHp(unit_data)
    end)
end

function M.UpdateVariables()
  BOT = GetBot()
  BOT_DATA = common_algorithms.GetBotData()

  ENEMY_HERO_DATA = common_algorithms.GetEnemyHero(
                      BOT_DATA,
                      constants.MAX_UNIT_SEARCH_RADIUS)

  ENEMY_CREEP_DATA = GetClosestCreep(
                       constants.MAX_UNIT_SEARCH_RADIUS,
                       common_algorithms.GetEnemyCreeps)

  ALLY_CREEP_DATA = GetClosestCreep(
                      constants.MAX_UNIT_SEARCH_RADIUS,
                      common_algorithms.GetAllyCreeps)

  ENEMY_TOWER_DATA = common_algorithms.GetEnemyBuildings(
                         BOT_DATA,
                         constants.MAX_UNIT_SEARCH_RADIUS)[1]

  ALLY_CREEPS_HP = common_algorithms.GetTotalHealth(
                     common_algorithms.GetAllyCreeps(
                       BOT_DATA,
                       constants.MAX_UNIT_SEARCH_RADIUS))

  ENEMY_CREEPS_HP = common_algorithms.GetTotalHealth(
                      common_algorithms.GetEnemyCreeps(
                        BOT_DATA,
                        constants.MAX_UNIT_SEARCH_RADIUS))
end

---------------------------------

function M.pre_laning()
  return M.pre_lasthit_enemy_creep()
         or M.pre_deny_ally_creep()
         or M.pre_harras_enemy_hero()
         or M.pre_attack_enemy_creep()
         or M.pre_attack_ally_creep()
         or M.pre_attack_enemy_tower()
end

function M.post_laning()
  return not M.pre_laning()
end

---------------------------------

local SIDE = {
  ENEMY = {},
  ALLY = {},
}

local function IsLastHit(BOT_DATA, unit_data)
  local incoming_damage = BOT_DATA.attack_damage
                          + common_algorithms.GetTotalDamageToUnit(
                              unit_data,
                              functions.GetUnitDistance(
                                BOT_DATA,
                                unit_data))

  if (100 < BOT_DATA.attack_damage or 2 < unit_data.armor) then
    incoming_damage = incoming_damage
                      * functions.GetDamageMultiplier(unit_data.armor)
  end

  return unit_data.health < incoming_damage
end

local function GetLastHitCreep(side)
  local creeps = functions.ternary(
    side == SIDE["ENEMY"],
    common_algorithms.GetEnemyCreeps(
      BOT_DATA,
      constants.MAX_UNIT_TARGET_RADIUS),
    common_algorithms.GetAllyCreeps(
      BOT_DATA,
      constants.MAX_UNIT_TARGET_RADIUS))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    function(unit_data)
      return common_algorithms.IsAttackTargetable(unit_data)
             and IsLastHit(BOT_DATA, unit_data)
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

  common_algorithms.AttackUnit(BOT_DATA, creep, false)
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

  common_algorithms.AttackUnit(BOT_DATA, target_data, false)
end

--------------------------------

local function GetMaxHealthCreep(side)
  local creeps = functions.ternary(
    side == SIDE["ENEMY"],
    common_algorithms.GetEnemyCreeps(
      BOT_DATA,
      BOT_DATA.attack_range),
    common_algorithms.GetAllyCreeps(
      BOT_DATA,
      BOT_DATA.attack_range))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMaxHealth,
    function(unit_data)
      return (side == SIDE["ENEMY"])
             or (side == SIDE["ALLY"]
                 and functions.GetRate(
                       unit_data.health,
                       unit_data.max_health) < 0.5)
    end)
end

function M.pre_attack_enemy_creep()
  local creep = GetMaxHealthCreep(SIDE["ENEMY"])

  return (ALLY_CREEPS_HP + BOT_DATA.attack_damage * 1.5) < ENEMY_CREEPS_HP
         and creep ~= nil
         and 0.5 < functions.GetRate(creep.health, creep.max_health)
end

function M.post_attack_enemy_creep()
  return not M.pre_attack_enemy_creep()
end

function M.attack_enemy_creep()
  local creep = GetMaxHealthCreep(SIDE["ENEMY"])

  common_algorithms.AttackUnit(BOT_DATA, creep, false)
end

--------------------------------

function M.pre_attack_ally_creep()
  local creep = GetMaxHealthCreep(SIDE["ALLY"])

  return (ENEMY_CREEPS_HP + BOT_DATA.attack_damage * 1.5) < ALLY_CREEPS_HP
         and creep ~= nil
end

function M.post_attack_ally_creep()
  return not M.pre_attack_ally_creep()
end

function M.attack_ally_creep()
  local creep = GetMaxHealthCreep(SIDE["ALLY"])

  common_algorithms.AttackUnit(BOT_DATA, creep, false)
end

--------------------------------

function M.pre_harras_enemy_hero()
  return ENEMY_HERO_DATA ~= nil
         and not common_algorithms.AreUnitsInRadius(
                   BOT_DATA,
                   constants.CREEP_AGRO_RADIUS,
                   common_algorithms.GetEnemyCreeps)
         and not common_algorithms.DoesTowerProtectEnemyUnit(
                   ENEMY_HERO_DATA)
         and not common_algorithms.DoesEnemyCreepAttack(
                   BOT_DATA,
                   ENEMY_CREEP_DATA,
                   ALLY_CREEP_DATA)
         and (not BOT_DATA.is_healing
              or BOT_DATA.health == BOT_DATA.max_health)
end

function M.post_harras_enemy_hero()
  return not M.pre_harras_enemy_hero()
end

function M.harras_enemy_hero()
  common_algorithms.AttackUnit(BOT_DATA, ENEMY_HERO_DATA, true)
end

--------------------------------

function M.pre_attack_enemy_tower()
  return ENEMY_TOWER_DATA ~= nil
         and common_algorithms.IsFocusedByCreeps(ENEMY_TOWER_DATA)
         and not common_algorithms.IsFocusedByTower(
                   BOT_DATA,
                   ENEMY_TOWER_DATA)
         and not common_algorithms.IsFocusedByEnemyHero(BOT_DATA)
         and not common_algorithms.IsFocusedByCreeps(BOT_DATA)
end

function M.post_attack_enemy_tower()
  return not M.pre_attack_enemy_tower()
end

function M.attack_enemy_tower()
  common_algorithms.AttackUnit(BOT_DATA, ENEMY_TOWER_DATA, false)
end

--------------------------------

function M.pre_stop_attack()
  return common_algorithms.IsUnitAttack(BOT_DATA)
end

function M.post_stop_attack()
  return not M.pre_stop_attack()
end

function M.stop_attack()
  local bot = GetBot()
  bot:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
