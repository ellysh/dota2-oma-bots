local M = {}

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local prepare_for_match = require(
  GetScriptDirectory() .."/utility/prepare_for_match")

---------------------------------

function M.post_laning()
  return false
end

function M.pre_laning()
  -- This is a objectives Dependency example

  return prepare_for_match.post_prepare_for_match()
end

---------------------------------

local function IsEnemyUnitsInAttackRange()
  local bot = GetBot()
  local creeps = common_algorithms.GetEnemyCreeps(
    bot,
    bot:GetAttackRange())

  local heroes = common_algorithms.GetEnemyHeroes(
    bot,
    bot:GetAttackRange())

  return not functions.IsArrayEmpty(creeps)
         or not functions.IsArrayEmpty(heroes)
end

function M.post_move_mid_front_lane()
  local target_location = GetLaneFrontLocation(
    GetTeam(),
    LANE_MID,
    0)

  local target_distance = GetUnitToLocationDistance(
    GetBot(),
    target_location)

  return (target_distance <= constants.MAP_LOCATION_RADIUS)
         or IsEnemyUnitsInAttackRange()
end

function M.pre_move_mid_front_lane()
  return not M.post_move_mid_front_lane()
end

function M.move_mid_front_lane()
  logger.Print("M.move_mid_front_lane()")

  local target_location = GetLaneFrontLocation(
    GetTeam(),
    LANE_MID,
    0)

  GetBot():Action_MoveToLocation(target_location)
end

---------------------------------

local SIDE = {
  ENEMY = {},
  ALLY = {},
}

local function IsLastHit(bot, unit_data)
  local bot_damage = bot:GetAttackDamage()

  return unit_data.health <= bot_damage
end

local function GetLastHitCreep(bot, side)
  local creeps = functions.ternary(
    side == SIDE["ENEMY"],
    common_algorithms.GetEnemyCreeps(bot, 1600),
    common_algorithms.GetAllyCreeps(bot, 1600))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    function(unit_data)
      return common_algorithms.IsAttackTargetable(unit_data)
             and IsLastHit(bot, unit_data)
    end)
end

local function IsUnitAttack(unit)
  local anim = unit:GetAnimActivity()
  return anim == ACTIVITY_ATTACK or anim == ACTIVITY_ATTACK2
end

local function IsAttackDone(unit)
  if not IsUnitAttack(unit) then
    return true
  end

  return unit:GetAttackPoint() <= unit:GetAnimCycle()
end

local function AttackUnit(bot, unit_data)
  local unit = all_units.GetUnit(unit_data)
  if (IsUnitAttack(bot) and IsAttackDone(bot)) then
    bot:Action_ClearActions(true)
    return
  end

  bot:SetTarget(unit)

  bot:Action_AttackUnit(unit, true)
end

function M.pre_lasthit_enemy_creep()
  local bot = GetBot()

  return (not IsUnitAttack(bot)

          or (IsUnitAttack(bot)
              and not IsAttackDone(bot)))

         and GetLastHitCreep(bot, SIDE["ENEMY"]) ~= nil
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local bot = GetBot()
  local creep = GetLastHitCreep(bot, SIDE["ENEMY"])

  AttackUnit(bot, creep)
end

---------------------------------

function M.pre_deny_ally_creep()
  local bot = GetBot()

  return (not IsUnitAttack(bot)

          or (IsUnitAttack(bot)
              and not IsAttackDone(bot)))

         and GetLastHitCreep(bot, SIDE["ALLY"]) ~= nil
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local bot = GetBot()
  local creep = GetLastHitCreep(bot, SIDE["ALLY"])

  AttackUnit(bot, creep)
end

--------------------------------

local function AreAllyCreepsInRadius(radius)
  local bot = GetBot()

  local units = common_algorithms.GetAllyCreeps(bot, radius)

  return not functions.IsArrayEmpty(units)
end

local function AreEnemyCreepsInRadius(radius)
  local bot = GetBot()

  local units = common_algorithms.GetEnemyCreeps(bot, radius)

  return not functions.IsArrayEmpty(units)
end

local function IsEnemyTowerInRadius(radius)
  local bot = GetBot()
  local units = common_algorithms.GetEnemyBuildings(bot, radius)

  return not functions.IsArrayEmpty(units)
end

function M.pre_positioning()
  local bot = GetBot()

  if IsUnitAttack(bot) and not IsAttackDone(bot) then
    return false end

  return (AreAllyCreepsInRadius(constants.MIN_CREEP_DISTANCE)
          and AreEnemyCreepsInRadius(constants.MIN_CREEP_DISTANCE))

          or (not AreAllyCreepsInRadius(constants.MIN_CREEP_DISTANCE)
              and AreEnemyCreepsInRadius(constants.MAX_CREEP_DISTANCE))

          or IsEnemyTowerInRadius(constants.MAX_TOWER_ATTACK_RANGE)
end

function M.post_positioning()
  return not M.pre_positioning()
end

function M.positioning()
  local bot = GetBot()
  bot:Action_MoveToLocation(GetShopLocation(GetTeam(), SHOP_HOME))
end

--------------------------------

local function IsFocusedByCreeps(unit)
  local unit_list = common_algorithms.GetEnemyCreeps(
                         unit,
                         constants.MAX_CREEP_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit)
end

local function IsFocusedByTower(unit)
  local unit_list = common_algorithms.GetEnemyBuildings(
                         unit,
                         constants.MAX_TOWER_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit)
end

local function IsFocusedByHeroes(unit)
  local unit_list = common_algorithms.GetEnemyHeroes(
                         unit,
                         constants.MAX_HERO_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit)
end

function M.pre_evasion()
  local bot = GetBot()

  return IsFocusedByCreeps(bot)
         or IsFocusedByTower(bot)
         or (IsFocusedByHeroes(bot)
             and AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS))
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  local bot = GetBot()
  bot:Action_MoveToLocation(GetShopLocation(GetTeam(), SHOP_HOME))
end

--------------------------------

local function GetEnemyHero(bot)
  local heroes = common_algorithms.GetEnemyHeroes(bot, 1600)

  return functions.GetElementWith(
    heroes,
    common_algorithms.CompareMinHealth,
    function(unit)
      return common_algorithms.IsAttackTargetable(unit)
    end)
end

function M.pre_harras_enemy_hero()
  local bot = GetBot()

  return not AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS)
         and not IsEnemyTowerInRadius(constants.MAX_TOWER_ATTACK_RANGE)

         and (not IsUnitAttack(bot)
              or (IsUnitAttack(bot)
                  and not IsAttackDone(bot)))

         and GetEnemyHero(bot) ~= nil
end

function M.post_harras_enemy_hero()
  return not M.pre_harras_enemy_hero()
end

function M.harras_enemy_hero()
  local bot = GetBot()
  local hero = GetEnemyHero(bot)

  AttackUnit(bot, hero)
end

--------------------------------

local function IsUnitMoving(unit)
  return unit:GetAnimActivity() == ACTIVITY_RUN
end

function M.pre_stop()
  local bot = GetBot()

  return IsUnitMoving(bot)
         or IsUnitAttack(bot)
end

function M.post_stop()
  return not M.pre_stop()
end

function M.stop()
  local bot = GetBot()
  bot:Action_ClearActions(true)
end

---------------------------------

local function GetEnemyCreep()
  local creeps = common_algorithms.GetEnemyCreeps(GetBot(), 1600)

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    nil)
end

function M.pre_turn()
  local bot = GetBot()
  return IsEnemyUnitsInAttackRange()
         and not M.pre_positioning()
         and not bot:IsFacingLocation(GetEnemyCreep().location, 30)
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  local bot = GetBot()
  local target = GetEnemyCreep()

  bot:Action_AttackUnit(all_units.GetUnit(target), true)
end

-- Provide an access to local functions for unit tests only

return M
