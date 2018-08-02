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

local function IsEnemyUnitInSpot(spot)
  local creeps = common_algorithms.GetEnemyCreeps(
                   BOT_DATA,
                   constants.MAX_UNIT_TARGET_RADIUS)

  local creep = functions.GetElementWith(
                  creeps,
                  common_algorithms.CompareMinDistance,
                  function(unit_data)
                    return map.IsUnitInSpot(unit_data, spot)
                  end)

  return (ENEMY_HERO_DATA ~= nil
          and (functions.GetDistance(ENEMY_HERO_DATA.location, spot)
                 <= ENEMY_HERO_DATA.attack_range
               or map.IsUnitInSpot(ENEMY_HERO_DATA, spot)))
         or creep ~= nil
end

local function GetSafeSpot()
  local hg_spot = map.GetAllySpot(BOT_DATA, "high_ground")
  if not IsEnemyUnitInSpot(hg_spot) then
    return hg_spot
  end

  local forest_top_spot = map.GetAllySpot(BOT_DATA, "forest_top")
  if not IsEnemyUnitInSpot(forest_top_spot) then
    return forest_top_spot
  end

  return map.GetAllySpot(BOT_DATA, "fountain")
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

  SAFE_SPOT = GetSafeSpot()
end

---------------------------------

function M.pre_positioning()
  return M.pre_move_mid_tower()
         or M.pre_increase_creeps_distance()
         or M.pre_decrease_creeps_distance()
         or M.pre_evasion()
         or M.pre_turn()
end

function M.post_positioning()
  return not M.pre_positioning()
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
  BOT:Action_MoveToLocation(SAFE_SPOT)
end

---------------------------------

function M.pre_decrease_creeps_distance()
  local creep_distance = functions.ternary(
                         common_algorithms.IsUnitLowHp(BOT_DATA)
                         or BOT_DATA.is_healing,
                         BOT_DATA.attack_range,
                         constants.BASE_CREEP_DISTANCE)

  return not AreEnemyCreepsInRadius(creep_distance)
         and not common_algorithms.DoesEnemyCreepAttack(
                   BOT_DATA,
                   ENEMY_CREEP_DATA,
                   ALLY_CREEP_DATA)
         and (ENEMY_CREEP_DATA ~= nil or ALLY_CREEP_DATA ~= nil)
         and (not BOT_DATA.is_healing
              or BOT_DATA.health == BOT_DATA.max_health)
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

function M.pre_evasion()
  return common_algorithms.IsFocusedByCreeps(BOT_DATA)
         or common_algorithms.IsFocusedByTower(BOT_DATA, ENEMY_TOWER_DATA)
         or (common_algorithms.IsFocusedByEnemyHero(BOT_DATA)
             and AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS))
         or common_algorithms.IsFocusedByUnknownUnit(BOT_DATA)
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  BOT:Action_MoveToLocation(SAFE_SPOT)

  action_timing.SetNextActionDelay(0.8)
end

--------------------------------

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

  action_timing.SetNextActionDelay(constants.DROW_RANGER_TURN_TIME)
end

function M.stop_attack_and_move()
  BOT:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
