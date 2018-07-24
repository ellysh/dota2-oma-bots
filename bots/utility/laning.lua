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

local recovery = require(
  GetScriptDirectory() .."/utility/recovery")

local buy_items = require(
  GetScriptDirectory() .."/utility/buy_items")

local kill_enemy_hero = require(
  GetScriptDirectory() .."/utility/kill_enemy_hero")

local upgrade_skills = require(
  GetScriptDirectory() .."/utility/upgrade_skills")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local BOT = {}
local BOT_DATA = {}
local ENEMY_CREEP_DATA = {}
local ENEMY_HERO_DATA = {}
local ALLY_CREEP_DATA = {}

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
end

---------------------------------

function M.post_laning()
  return recovery.pre_recovery()
end

function M.pre_laning()
  return prepare_for_match.post_prepare_for_match()
         and not BOT_DATA.is_casting
         and not recovery.pre_recovery()
         and not buy_items.pre_buy_items()
         and not kill_enemy_hero.pre_kill_enemy_hero()
         and not upgrade_skills.pre_upgrade_skills()
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

         or (IsEnemyHeroNearCreeps()
             and ENEMY_HERO_DATA ~= nil
             and functions.GetUnitDistance(BOT_DATA, ENEMY_HERO_DATA)
                   <= BOT_DATA.attack_range))

         and not M.pre_lasthit_enemy_creep()
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
               4)
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
         and not M.pre_lasthit_enemy_creep()
         and not M.pre_deny_ally_creep()
         and not M.pre_harras_enemy_hero()
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

  return unit_data.health <= incoming_damage
end

local function GetLastHitCreep(BOT_DATA, side)
  local creeps = functions.ternary(
    side == SIDE["ENEMY"],
    common_algorithms.GetEnemyCreeps(BOT_DATA, 1600),
    common_algorithms.GetAllyCreeps(BOT_DATA, 1600))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    function(unit_data)
      return common_algorithms.IsAttackTargetable(unit_data)
             and IsLastHit(BOT_DATA, unit_data)
    end)
end

function M.pre_lasthit_enemy_creep()
  return GetLastHitCreep(BOT_DATA, SIDE["ENEMY"]) ~= nil
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local creep = GetLastHitCreep(BOT_DATA, SIDE["ENEMY"])

  common_algorithms.AttackUnit(BOT_DATA, creep, false)
end

---------------------------------

function M.pre_deny_ally_creep()
  local target_data = GetLastHitCreep(BOT_DATA, SIDE["ALLY"])

  return target_data ~= nil
         and functions.GetRate(target_data.health, target_data.max_health)
               < constants.UNIT_HALF_HEALTH_LEVEL
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local target_data = GetLastHitCreep(BOT_DATA, SIDE["ALLY"])

  common_algorithms.AttackUnit(BOT_DATA, target_data, false)
end

--------------------------------

local function IsFocusedByCreeps(unit_data)
  local unit_list = common_algorithms.GetEnemyCreeps(
                         unit_data,
                         constants.MAX_CREEP_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit_data)
end

local function IsFocusedByTower(unit_data)
  local unit_list = common_algorithms.GetEnemyBuildings(
                         unit_data,
                         constants.MAX_UNIT_SEARCH_RADIUS)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit_data)
end

local function IsFocusedByHeroes(unit_data)
   return ENEMY_HERO_DATA ~= nil
          and functions.GetUnitDistance(BOT_DATA, ENEMY_HERO_DATA)
                <= ENEMY_HERO_DATA.attack_range
          and 0 < common_algorithms.GetTotalDamage(
                    {ENEMY_HERO_DATA},
                    unit_data)
end

local function IsFocusedByUnknownUnit(unit_data)
  return common_algorithms.IsUnitShootTarget(
           nil,
           unit_data,
           constants.MAX_HERO_ATTACK_RANGE)
end

function M.pre_evasion()
  return IsFocusedByCreeps(BOT_DATA)
         or IsFocusedByTower(BOT_DATA)
         or (IsFocusedByHeroes(BOT_DATA)
             and AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS))
         or IsFocusedByUnknownUnit(BOT_DATA)
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  BOT:Action_MoveToLocation(map.GetAllySpot(BOT_DATA, "fountain"))
end

--------------------------------

function M.pre_harras_enemy_hero()
  return ENEMY_HERO_DATA ~= nil
         and not AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS)
         and not common_algorithms.DoesTowerProtectEnemyUnit(
                   ENEMY_HERO_DATA)
         and not EnemyCreepAttacks()
end

function M.post_harras_enemy_hero()
  return not M.pre_harras_enemy_hero()
end

function M.harras_enemy_hero()
  common_algorithms.AttackUnit(BOT_DATA, ENEMY_HERO_DATA, true)
end

--------------------------------

function M.pre_stop()
  return common_algorithms.IsUnitMoving(BOT_DATA)
         or common_algorithms.IsUnitAttack(BOT_DATA)
end

function M.post_stop()
  return not M.pre_stop()
end

function M.stop()
  BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_turn()
  return AreEnemyCreepsInRadius(BOT_DATA.attack_range)
         and ENEMY_CREEP_DATA ~= nil
         and not BOT:IsFacingLocation(ENEMY_CREEP_DATA.location, 30)
         and not M.pre_increase_creeps_distance()
         and not M.pre_decrease_creeps_distance()
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  BOT:Action_AttackUnit(all_units.GetUnit(ENEMY_CREEP_DATA), true)
end

-- Provide an access to local functions for unit tests only

return M
