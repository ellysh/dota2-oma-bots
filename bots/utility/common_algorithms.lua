local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local M = {}

function M.GetBotData()
  return all_units.GetUnitData(GetBot())
end

function M.GetItem(unit_data, item_name)
  if unit_data == nil then
    return nil end

  return functions.GetElementWith(
    unit_data.items,
    nil,
    function(item)
      return item:GetName() == item_name
    end)
end

function M.IsItemPresent(unit_data, item_name)
  return M.GetItem(unit_data, item_name) ~= nil
end

function M.IsAttackTargetable(unit_data)
  return unit_data.is_alive
         and not unit_data.is_invulnerable
         and not unit_data.is_illusion
end

function M.CompareMinHealth(t, a, b)
  return t[a].health < t[b].health
end

local function GetNormalizedRadius(radius)
  if radius == nil or radius == 0 then
    return constants.DEFAULT_ABILITY_USAGE_RADIUS
  end

  -- TODO: Trick with MAX_ABILITY_USAGE_RADIUS breaks Sniper's ult.
  -- But the GetNearbyHeroes function has the maximum radius 1600.

  return functions.ternary(
    constants.MAX_ABILITY_USAGE_RADIUS < radius,
    constants.MAX_ABILITY_USAGE_RADIUS,
    radius)
end

local function GetUnitsInRadius(unit_data, radius, get_function)
  local unit_list = get_function(unit)

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

  return unit_data.attack_point <= unit_data.anim_cycle
end

function M.IsUnitAttackTarget(unit_data, target_data)
  -- TODO: Consider unit's attack range in this functions

  return M.IsUnitAttack(unit_data)
         and unit:IsFacingLocation(target_data.location, 2)
end

function M.GetTotalDamage(unit_list, target_data)
  if unit_list == nil or #unit_list == 0 then
    return 0 end

  local total_damage = 0

  functions.DoWithKeysAndElements(
    unit_list,
    function(_, unit_data)
      if unit_data.is_alive
         and M.IsUnitAttackTarget(unit_data, target_data) then

        total_damage = total_damage + unit_data.attack_damage
      end
    end)

  return total_damage
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
