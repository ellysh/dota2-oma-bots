local M = {}

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

---------------------------------

function M.post_laning()
  return recovery.pre_recovery()
end

function M.pre_laning()
  -- This is a objectives Dependency example

  local bot_data = common_algorithms.GetBotData()

  return prepare_for_match.post_prepare_for_match()
         and not bot_data.is_casting
end

---------------------------------

local function AreUnitsInRadius(radius, get_function)
  local bot_data = common_algorithms.GetBotData()
  local units = get_function(bot_data, radius)

  return not functions.IsArrayEmpty(units)
end

local function AreAllyCreepsInRadius(radius)
  return AreUnitsInRadius(radius, common_algorithms.GetAllyCreeps)
end

local function AreEnemyCreepsInRadius(radius)
  return AreUnitsInRadius(radius, common_algorithms.GetEnemyCreeps)
end

local function IsEnemyTowerInRadius(radius)
  return AreUnitsInRadius(radius, common_algorithms.GetEnemyBuildings)
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
         or AreEnemyCreepsInRadius(constants.MIN_CREEP_DISTANCE)
end

function M.pre_move_mid_front_lane()
  return not M.post_move_mid_front_lane()
end

function M.move_mid_front_lane()
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

local function IsLastHit(bot_data, unit_data)
  local incoming_damage = bot_data.attack_damage
                          + common_algorithms.GetTotalDamageToUnit(
                              unit_data)

  return unit_data.health <= incoming_damage
end

local function GetLastHitCreep(bot_data, side)
  local creeps = functions.ternary(
    side == SIDE["ENEMY"],
    common_algorithms.GetEnemyCreeps(bot_data, 1600),
    common_algorithms.GetAllyCreeps(bot_data, 1600))

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    function(unit_data)
      return common_algorithms.IsAttackTargetable(unit_data)
             and IsLastHit(bot_data, unit_data)
    end)
end

local function AttackUnit(bot_data, unit_data)
  local bot = GetBot()
  local unit = all_units.GetUnit(unit_data)

  if (common_algorithms.IsUnitAttack(bot_data)
      and common_algorithms.IsAttackDone(bot_data)) then
    bot:Action_ClearActions(true)
    return
  end

  bot:Action_AttackUnit(unit, true)
end

function M.pre_lasthit_enemy_creep()
  local bot_data = common_algorithms.GetBotData()

  return (not common_algorithms.IsUnitAttack(bot_data)

          or (common_algorithms.IsUnitAttack(bot_data)
              and not common_algorithms.IsAttackDone(bot_data)))

         and GetLastHitCreep(bot_data, SIDE["ENEMY"]) ~= nil
end

function M.post_lasthit_enemy_creep()
  return not M.pre_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  local bot_data = common_algorithms.GetBotData()
  local creep = GetLastHitCreep(bot_data, SIDE["ENEMY"])

  AttackUnit(bot_data, creep)
end

---------------------------------

function M.pre_deny_ally_creep()
  local bot_data = common_algorithms.GetBotData()

  return (not common_algorithms.IsUnitAttack(bot_data)

          or (common_algorithms.IsUnitAttack(bot_data)
              and not common_algorithms.IsAttackDone(bot_data)))

         and GetLastHitCreep(bot_data, SIDE["ALLY"]) ~= nil
end

function M.post_deny_ally_creep()
  return not M.pre_deny_ally_creep()
end

function M.deny_ally_creep()
  local bot_data = common_algorithms.GetBotData()
  local creep = GetLastHitCreep(bot_data, SIDE["ALLY"])

  AttackUnit(bot_data, creep)
end

--------------------------------

function M.pre_positioning()
  local bot_data = common_algorithms.GetBotData()

  if common_algorithms.IsUnitAttack(bot_data)
     and not common_algorithms.IsAttackDone(bot_data) then
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

local function IsFocusedByCreeps(unit_data)
  local unit_list = common_algorithms.GetEnemyCreeps(
                         unit_data,
                         constants.MAX_CREEP_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit_data)
end

local function IsFocusedByTower(unit_data)
  local unit_list = common_algorithms.GetEnemyBuildings(
                         unit_data,
                         constants.MAX_TOWER_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit_data)
end

local function IsFocusedByHeroes(unit_data)
  local unit_list = common_algorithms.GetEnemyHeroes(
                         unit_data,
                         constants.MAX_HERO_ATTACK_RANGE)

   return 0 < common_algorithms.GetTotalDamage(unit_list, unit_data)
end

function M.pre_evasion()
  local bot_data = common_algorithms.GetBotData()

  return IsFocusedByCreeps(bot_data)
         or IsFocusedByTower(bot_data)
         or (IsFocusedByHeroes(bot_data)
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

function M.pre_harras_enemy_hero()
  local bot_data = common_algorithms.GetBotData()

  return not AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS)
         and not IsEnemyTowerInRadius(constants.MAX_TOWER_ATTACK_RANGE)

         and (not common_algorithms.IsUnitAttack(bot_data)
              or (common_algorithms.IsUnitAttack(bot_data)
                  and not common_algorithms.IsAttackDone(bot_data)))

         and common_algorithms.GetEnemyHero(bot_data) ~= nil
end

function M.post_harras_enemy_hero()
  return not M.pre_harras_enemy_hero()
end

function M.harras_enemy_hero()
  local bot_data = common_algorithms.GetBotData()
  local hero_data = common_algorithms.GetEnemyHero(bot_data)

  AttackUnit(bot_data, hero_data)
end

--------------------------------

local function IsUnitMoving(unit_data)
  return unit_data.anim_activity == ACTIVITY_RUN
end

function M.pre_stop()
  local bot_data = common_algorithms.GetBotData()

  return IsUnitMoving(bot_data)
         or common_algorithms.IsUnitAttack(bot_data)
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
  local bot_data = common_algorithms.GetBotData()
  local creeps = common_algorithms.GetEnemyCreeps(
    bot_data,
    bot_data.attack_range)

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinHealth,
    nil)
end

function M.pre_turn()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()
  local target = GetEnemyCreep()

  return AreEnemyCreepsInRadius(bot_data.attack_range)
         and target ~= nil
         and not M.pre_positioning()
         and not bot:IsFacingLocation(target.location, 30)
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
