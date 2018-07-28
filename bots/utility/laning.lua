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

local prepare_for_match = require(
  GetScriptDirectory() .."/utility/prepare_for_match")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local BOT = {}
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
  return not BOT_DATA.is_casting
end

function M.post_laning()
  return not M.pre_laning()
end

---------------------------------

local function AreAllyCreepsInRadius(radius)
  return common_algorithms.AreUnitsInRadius(
    BOT_DATA,
    radius,
    common_algorithms.GetAllyCreeps)
end

local function AreEnemyCreepsInRadius(radius)
  return common_algorithms.AreUnitsInRadius(
    BOT_DATA,
    radius,
    common_algorithms.GetEnemyCreeps)
end

function M.pre_move_mid_tower()
  local target_location = map.GetAllySpot(BOT_DATA, "high_ground")

  return (not AreAllyCreepsInRadius(constants.MAX_UNIT_SEARCH_RADIUS)
          or functions.GetDistance(
               map.GetAllySpot(BOT_DATA, "fountain"),
               BOT_DATA.location)
             < 3000)
         and not map.IsUnitInSpot(BOT_DATA, target_location)
end

function M.post_move_mid_tower()
  return not M.pre_move_mid_tower()
end

function M.move_mid_tower()
  local target_location = map.GetAllySpot(BOT_DATA, "high_ground")

  GetBot():Action_MoveToLocation(target_location)
end

---------------------------------

local function IsEnemyHeroNearCreeps()
  if ENEMY_HERO_DATA == nil then
    return false end

  local creeps = common_algorithms.GetEnemyCreeps(
                       BOT_DATA,
                       constants.MAX_UNIT_SEARCH_RADIUS)

  if functions.IsTableEmpty(creeps) then
    return false end

  local creep_data = functions.GetElementWith(
                       creeps,
                       nil,
                       function(unit_data)
                         return constants.CREEP_AGRO_RADIUS
                          < functions.GetUnitDistance(
                              ENEMY_HERO_DATA,
                              unit_data)
                       end)


  return creep_data == nil
end

function M.pre_increase_creeps_distance()
  return (AreEnemyCreepsInRadius(constants.MIN_CREEP_DISTANCE)

         or (not AreAllyCreepsInRadius(constants.MIN_CREEP_DISTANCE)
             and AreEnemyCreepsInRadius(constants.MAX_CREEP_DISTANCE))

         or map.IsUnitInEnemyTowerAttackRange(BOT_DATA)

         or (ENEMY_HERO_DATA ~= nil
             and IsEnemyHeroNearCreeps()
             and functions.GetUnitDistance(BOT_DATA, ENEMY_HERO_DATA)
                   <= BOT_DATA.attack_range - 50))

         or (ALLY_CREEPS_HP * 3) < ENEMY_CREEPS_HP
end

function M.post_increase_creeps_distance()
  return not M.pre_increase_creeps_distance()
end

function M.increase_creeps_distance()
  BOT:Action_MoveToLocation(map.GetAllySpot(BOT_DATA, "fountain"))
end

---------------------------------

local function EnemyCreepAttacks()
  return ENEMY_CREEP_DATA ~= nil

         and ((ALLY_CREEP_DATA ~= nil
               and not functions.IsTargetBetweenUnits(
                         ALLY_CREEP_DATA,
                         BOT_DATA,
                         ENEMY_CREEP_DATA))
              or ALLY_CREEP_DATA == nil)

         and all_units.GetUnit(ENEMY_CREEP_DATA):IsFacingLocation(
               BOT_DATA.location,
               constants.TURN_TARGET_MAX_DEGREE)
end

---------------------------------

function M.pre_decrease_creeps_distance()
  local creep_distance = functions.ternary(
                         common_algorithms.IsUnitLowHp(BOT_DATA)
                         or BOT_DATA.is_healing,
                         BOT_DATA.attack_range,
                         constants.BASE_CREEP_DISTANCE)

  return not AreEnemyCreepsInRadius(creep_distance)
         and not EnemyCreepAttacks()
         and (ENEMY_CREEP_DATA ~= nil or ALLY_CREEP_DATA ~= nil)
         and (not BOT_DATA.is_healing
              or BOT_DATA.health == BOT_DATA.max_health)
         and ENEMY_CREEPS_HP < (ALLY_CREEPS_HP * 3)
end

function M.post_decrease_creeps_distance()
  return not M.pre_decrease_creeps_distance()
end

function M.decrease_creeps_distance()
  local target_data = ENEMY_CREEP_DATA

  if target_data == nil then
    target_data = ALLY_CREEP_DATA
  end

  GetBot():Action_MoveToLocation(target_data.location)
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

local function IsFocusedByCreeps(unit_data)
  local creeps = common_algorithms.GetEnemyCreeps(
                         unit_data,
                         constants.MAX_CREEP_ATTACK_RANGE)

  return nil ~= functions.GetElementWith(
                  creeps,
                  nil,
                  function(creep_data)
                    return common_algorithms.IsUnitAttackTarget(
                             creep_data,
                             unit_data)
                  end)
end

local function IsFocusedByTower(unit_data)
   return ENEMY_TOWER_DATA ~= nil
          and common_algorithms.IsUnitAttackTarget(
                ENEMY_TOWER_DATA,
                unit_data)
end

function M.pre_evasion()
  return IsFocusedByCreeps(BOT_DATA)
         or IsFocusedByTower(BOT_DATA)
         or (common_algorithms.IsFocusedByEnemyHero(BOT_DATA)
             and AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS))
         or common_algorithms.IsFocusedByUnknownUnit(BOT_DATA)
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  BOT:Action_MoveToLocation(map.GetAllySpot(BOT_DATA, "fountain"))

  action_timing.SetNextActionDelay(1.6)
end

--------------------------------

function M.pre_harras_enemy_hero()
  return ENEMY_HERO_DATA ~= nil
         and not AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS)
         and not common_algorithms.DoesTowerProtectEnemyUnit(
                   ENEMY_HERO_DATA)
         and not EnemyCreepAttacks()
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
         and IsFocusedByCreeps(ENEMY_TOWER_DATA)
         and not IsFocusedByTower(BOT_DATA)
         and not common_algorithms.IsFocusedByEnemyHero(BOT_DATA)
         and not IsFocusedByCreeps(BOT_DATA)
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
  BOT:Action_ClearActions(true)
end

--------------------------------

function M.pre_stop_attack_and_move()
  return common_algorithms.IsUnitMoving(BOT_DATA)
         or common_algorithms.IsUnitAttack(BOT_DATA)
end

function M.post_stop_attack_and_move()
  return not M.pre_stop_attack_and_move()
end

function M.stop_attack_and_move()
  BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_turn()
  return AreEnemyCreepsInRadius(BOT_DATA.attack_range)
         and ENEMY_CREEP_DATA ~= nil
         and not BOT:IsFacingLocation(
                   ENEMY_CREEP_DATA.location,
                   constants.TURN_TARGET_MAX_DEGREE)
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  BOT:Action_AttackUnit(all_units.GetUnit(ENEMY_CREEP_DATA), true)
end

-- Provide an access to local functions for unit tests only

return M
