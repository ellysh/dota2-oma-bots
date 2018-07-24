local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local map = require(
  GetScriptDirectory() .."/utility/map")

local M = {}

function M.GetCourierData()
  return all_units.GetUnitData(GetCourier(0))
end

function M.GetBotData()
  return all_units.GetUnitData(GetBot())
end

function M.GetItem(unit_data, item_name)
  return functions.GetElementWith(
    unit_data.items,
    nil,
    function(item)
      return not item:IsNull()
             and item:GetName() == item_name
    end)
end

function M.IsItemPresent(unit_data, item_name)
  return M.GetItem(unit_data, item_name) ~= nil
end

function M.IsItemInInventory(unit_data, item_name)
  local unit = all_units.GetUnit(unit_data)
  local slot = unit:FindItemSlot(item_name)

  return unit:GetItemSlotType(slot) == ITEM_SLOT_TYPE_MAIN
end

function M.IsAttackTargetable(unit_data)
  return unit_data.is_alive
         and not unit_data.is_invulnerable
         and not unit_data.is_illusion
end

function M.CompareMinHealth(t, a, b)
  return t[a].health < t[b].health
end

function M.CompareMinDistance(t, a, b)
  local bot_data = M.GetBotData()

  return functions.GetUnitDistance(bot_data, t[a])
         < functions.GetUnitDistance(bot_data, t[b])
end

-- TODO: Remove this function because we are searching units in
-- the UNIT_LIST now.

local function GetNormalizedRadius(radius)
  if radius == nil or radius == 0 then
    return constants.MAX_UNIT_SEARCH_RADIUS
  end

  return functions.ternary(
    constants.MAX_UNIT_SEARCH_RADIUS < radius,
    constants.MAX_UNIT_SEARCH_RADIUS,
    radius)
end

local function GetUnitsInRadius(unit_data, radius, get_function)
  local unit_list = get_function(unit_data)

  return functions.GetListWith(
    unit_list,
    nil,
    function(check_unit_data)
      return functions.GetUnitDistance(unit_data, check_unit_data)
               <= GetNormalizedRadius(radius)
    end)
end

function M.GetEnemyHeroes(unit_data, radius)
  return GetUnitsInRadius(unit_data, radius, all_units.GetEnemyHeroesData)
end

function M.GetAllyHeroes(unit_data, radius)
  -- Result of this function includes the "bot" unit

  return GetUnitsInRadius(unit_data, radius, all_units.GetAllyHeroesData)
end

function M.GetEnemyCreeps(unit_data, radius)
  return GetUnitsInRadius(unit_data, radius, all_units.GetEnemyCreepsData)
end

function M.GetAllyCreeps(unit_data, radius)
  return GetUnitsInRadius(unit_data, radius, all_units.GetAllyCreepsData)
end

function M.GetEnemyBuildings(unit_data, radius)
  return GetUnitsInRadius(
    unit_data,
    radius,
    all_units.GetEnemyBuildingsData)
end

function M.GetAllyBuildings(unit_data, radius)
  return GetUnitsInRadius(
    unit_data,
    radius,
    all_units.GetAllyBuildingsData)
end

function M.IsUnitAttack(unit_data)
  return unit_data.anim_activity == ACTIVITY_ATTACK
         or unit_data.anim_activity == ACTIVITY_ATTACK2
end

function M.IsAttackDone(unit_data)
  if not M.IsUnitAttack(unit_data) then
    return true
  end

  return unit_data.anim_attack_point <= unit_data.anim_cycle
end

-- We should pass unit handle to this function for detecting a "nil" caster
function M.IsUnitShootTarget(unit, target_data, target_distance)
  local unit_projectile = functions.GetElementWith(
    target_data.incoming_projectiles,
    nil,
    function(projectile)
      return projectile.caster == unit
             and (target_distance == nil
                  or functions.GetDistance(
                       projectile.location,
                       target_data.location) <= target_distance)
    end)

  return unit_projectile ~= nil
end

function M.IsUnitAttackTarget(unit_data, target_data, target_distance)
  if functions.GetUnitDistance(unit_data, target_data)
     <= constants.MAX_MELEE_ATTACK_RANGE then

    local unit = all_units.GetUnit(unit_data)

    return M.IsUnitAttack(unit_data)
           and unit:IsFacingLocation(target_data.location, 2)
           and not M.IsAttackDone(unit_data)
  else
    return M.IsUnitShootTarget(
             all_units.GetUnit(unit_data),
             target_data,
             target_distance)
  end
end

function M.GetTotalDamage(unit_list, target_data, target_distance)
  if unit_list == nil or #unit_list == 0 then
    return 0 end

  local total_damage = 0

  functions.DoWithKeysAndElements(
    unit_list,
    function(_, unit_data)
      if unit_data.is_alive
         and M.IsUnitAttackTarget(
               unit_data,
               target_data,
               target_distance) then

        total_damage = total_damage + unit_data.attack_damage
      end
    end)

  return total_damage
end

function M.GetTotalDamageToUnit(unit_data, target_distance)
  local result = 0

  local unit_list = M.GetEnemyCreeps(
                         unit_data,
                         constants.MAX_CREEP_ATTACK_RANGE)

  result = result + M.GetTotalDamage(
                      unit_list,
                      unit_data,
                      target_distance)

  unit_list = M.GetEnemyBuildings(
                         unit_data,
                         constants.MAX_TOWER_ATTACK_RANGE)

  result = result + M.GetTotalDamage(
                      unit_list,
                      unit_data,
                      target_distance)

  unit_list = M.GetEnemyHeroes(
                         unit_data,
                         constants.MAX_HERO_ATTACK_RANGE)

  result = result + M.GetTotalDamage(
                      unit_list,
                      unit_data,
                      target_distance)

  unit_list = M.GetAllyHeroes(
                         unit_data,
                         constants.MAX_HERO_ATTACK_RANGE)

  result = result + M.GetTotalDamage(
                      unit_list,
                      unit_data,
                      target_distance)

  return result
end

function M.GetEnemyHero(unit_data, radius)
  local heroes = M.GetEnemyHeroes(
    unit_data,
    radius)

  return functions.GetElementWith(
    heroes,
    M.CompareMinHealth,
    function(hero_data)
      return M.IsAttackTargetable(hero_data)
    end)
end

function M.AreUnitsInRadius(unit_data, radius, get_function)
  local units = get_function(unit_data, radius)

  return not functions.IsTableEmpty(units)
end

function M.IsUnitMoving(unit_data)
  return unit_data.anim_activity == ACTIVITY_RUN
end

function M.IsUnitLowHp(unit_data)
  local unit_health = unit_data.health
                      - M.GetTotalDamageToUnit(unit_data, nil)

  return unit_health <= constants.UNIT_LOW_HEALTH
         or functions.GetRate(unit_health, unit_data.max_health)
            <= constants.UNIT_LOW_HEALTH_LEVEL
end

function M.AttackUnit(bot_data, unit_data, is_modifier)
  local bot = GetBot()
  local unit = all_units.GetUnit(unit_data)
  local ability = bot:GetAbilityByName("drow_ranger_frost_arrows")

  if is_modifier and ability:IsFullyCastable() then
    bot:Action_UseAbilityOnEntity(ability, unit)
  else
    bot:Action_AttackUnit(unit, true)
  end

  local attack_point = constants.DROW_RANGER_ATTACK_POINT / bot_data.attack_speed

  action_timing.SetNextActionDelay(attack_point)
end

function M.BuyItem(item_name)
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem(item_name)
end

function M.DoesTowerProtectEnemyUnit(unit_data)
  local bot_data = M.GetBotData()
  local tower_spot = map.GetEnemySpot(unit_data, "tower_tier_1_attack")

  local bot_tower_distance = functions.GetDistance(
                               bot_data.location,
                               tower_spot)

  return bot_tower_distance < constants.MAX_TOWER_ATTACK_RANGE
         or bot_tower_distance
              < functions.GetUnitDistance(bot_data, unit_data)
end

function M.DoesBotOrCourierHaveItem(item_name)
  local courier_data = M.GetCourierData()
  local bot_data = M.GetBotData()

  return M.IsItemPresent(bot_data, item_name)
         or M.IsItemPresent(
              courier_data,
              item_name)
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
