local M = {}

local functions = require(
  GetScriptDirectory() .."/utility/functions")

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

local function IsLastHit(bot, unit)
  -- TODO: Consider incoming projectiles here
  return unit:GetHealth() <= 1.6 * bot:GetAttackDamage()
end

local CREEP_TYPE = {
  ENEMY = {},
  ALLY = {},
}

local function GetLastHitCreep(bot, creep_type)
  local creeps = functions.ternary(
    creep_type == CREEP_TYPE["ENEMY"],
    common_algorithms.GetEnemyCreeps(bot, 1600),
    common_algorithms.GetAllyCreeps(bot, 1600))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    function(unit)
      return common_algorithms.IsAttackTargetable(unit)
             and IsLastHit(bot, unit)
    end)
end

local function IsUnitAttack(unit)
  local anim = unit:GetAnimActivity()
  return anim == ACTIVITY_ATTACK or anim == ACTIVITY_ATTACK2
end

local function AttackUnit(bot, unit)
  if (IsUnitAttack(bot) and IsAttackDone(bot)) then
    bot:Action_ClearActions(true)
    return
  end

  bot:SetTarget(unit)

  bot:Action_AttackUnit(unit, true)
end

function M.pre_lasthit_enemy_creep()
  local bot = GetBot()

  return not IsUnitAttack(bot)
         and GetLastHitCreep(bot, CREEP_TYPE["ENEMY"]) ~= nil
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local bot = GetBot()
  local creep = GetLastHitCreep(bot, CREEP_TYPE["ENEMY"])

  AttackUnit(bot, creep)
end

---------------------------------

function M.pre_deny_ally_creep()
  local bot = GetBot()

  return not IsUnitAttack(bot)
         and GetLastHitCreep(bot, CREEP_TYPE["ALLY"]) ~= nil
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local bot = GetBot()
  local creep = GetLastHitCreep(bot, CREEP_TYPE["ALLY"])

  AttackUnit(bot, creep)
end

--------------------------------

local function AreEnemyCreepsInRadius(radius)
  local bot = GetBot()

  local units = common_algorithms.GetEnemyCreeps(bot, radius)

  return not functions.IsArrayEmpty(units)
end

local function IsEnemyTowerInRadius(radius)
  local bot = GetBot()

  local units = bot:GetNearbyTowers(radius, true)

  return not functions.IsArrayEmpty(units)
end

function M.pre_positioning()
  return AreEnemyCreepsInRadius(constants.MIN_CREEP_DISTANCE)
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

local function IsFocusedByEnemies()
  local bot = GetBot()
  local enemy_towers = bot:GetNearbyTowers(
    constants.MAX_TOWER_ATTACK_RANGE,
    true)

  local enemy_creeps = common_algorithms.GetEnemyCreeps(
    bot,
    constants.MAX_CREEP_ATTACK_RANGE)

  local total_damage =
    common_algorithms.GetTotalDamage(enemy_towers, bot) +
    common_algorithms.GetTotalDamage(enemy_creeps, bot)

  return 0 < total_damage
end

function M.pre_evasion()
  return IsFocusedByEnemies()
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  local bot = GetBot()
  bot:Action_MoveToLocation(GetShopLocation(GetTeam(), SHOP_HOME))
end

--------------------------------

local function IsEnemyTowerInRadius(radius)
  local bot = GetBot()
  local units = bot:GetNearbyTowers(radius, true)

  return not functions.IsArrayEmpty(units)
end

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
         and not IsUnitAttack(bot)
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

local function GetEnemyBuilding(bot)
  local units = common_algorithms.GetEnemyBuildings(bot, 1600)

  return functions.GetElementWith(
    units,
    common_algorithms.CompareMinHealth,
    function(unit)
      return common_algorithms.IsAttackTargetable(unit)
    end)
end

function M.pre_attack_enemy_building()
  -- TODO: This move should be part of the separate objective

  return false
  --[[
  -- TODO: Check if it is safe to attack building
  local bot = GetBot()

  return not IsUnitAttack(bot)
         and GetEnemyBuilding(bot) ~= nil
  --]]
end

function M.post_attack_enemy_building()
  return not M.pre_attack_enemy_building()
end

function M.attack_enemy_building()
  local bot = GetBot()
  local unit = GetEnemyBuilding(bot)

  AttackUnit(bot, unit)
end

---------------------------------

local function IsAttackDone(unit)
  if not IsUnitAttack(unit) then
    return true
  end

  return unit:GetAttackPoint() <= unit:GetAnimCycle()
end

local function IsUnitMoving(unit)
  return unit:GetAnimActivity() == ACTIVITY_RUN
end

function M.pre_stop()
  local bot = GetBot()
  local action = bot:GetCurrentActionType()

  return (IsUnitAttack(bot) and IsAttackDone(bot)) or IsUnitMoving(bot)
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
  return common_algorithms.GetEnemyCreeps(GetBot(), 1600)[1]
end

function M.pre_turn()
  local bot = GetBot()
  return IsEnemyUnitsInAttackRange()
         and not IsUnitAttack(bot)
         and not IsUnitMoving(bot)
         and not bot:IsFacingLocation(GetEnemyCreep():GetLocation(), 30)
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  local bot = GetBot()

  if not IsUnitMoving(bot) then
    bot:Action_MoveToLocation(GetEnemyCreep():GetLocation())
  else
    bot:Action_ClearActions(true)
  end
end

---------------------------------

function M.pre_tp_out()
  -- TODO: Implement this
  return false
end

-- Provide an access to local functions for unit tests only

return M
