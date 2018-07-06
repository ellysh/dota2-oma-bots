local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local M = {}

function M.GetItem(unit, item_name)
  local unit_data = all_units.GetUnitData(unit)

  if unit_data == nil then
    return nil end

  return functions.GetElementWith(
    unit_data.items,
    nil,
    function(item)
      return item:GetName() == item_name
    end)
end

function M.IsItemPresent(unit, item_name)
  return M.GetItem(unit, item_name) ~= nil
end

function M.IsAttackTargetable(unit)
  return unit:IsAlive()
         and not unit:IsInvulnerable()
         and not unit:IsIllusion()
end

function M.CompareMinHealth(t, a, b)
  return t[a]:GetHealth() < t[b]:GetHealth()
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

local function GetUnitsInRadius(unit, radius, get_function)
  local unit_list = get_function(unit)
  local unit_data = all_units.GetUnitData(unit)

  return functions.GetListWith(
    unit_list,
    nil,
    function(check_unit_data)
      return functions.GetUnitDistance(unit_data, check_unit_data)
               <= GetNormalizedRadius(radius)
    end)
end

function M.GetEnemyHeroes(unit, radius)
  return GetUnitsInRadius(unit, radius, all_units.GetEnemyHeroesData)
end

function M.GetAllyHeroes(unit, radius)
  -- Result of this function includes the "bot" unit

  return GetUnitsInRadius(unit, radius, all_units.GetAllyHeroesData)
end

function M.GetEnemyCreeps(unit, radius)
  return GetUnitsInRadius(unit, radius, all_units.GetEnemyCreepsData)
end

function M.GetAllyCreeps(unit, radius)
  return GetUnitsInRadius(unit, radius, all_units.GetAllyCreepsData)
end

function M.GetTotalDamage(units, target)
  if units == nil or #units == 0 or target == nil then
    return 0 end

  local total_damage = 0

  functions.DoWithKeysAndElements(
    units,
    function(_, unit)
      if unit:IsAlive() and unit:GetAttackTarget() == target then
        total_damage = total_damage + unit:GetAttackDamage()
      end
    end)

  return total_damage
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
