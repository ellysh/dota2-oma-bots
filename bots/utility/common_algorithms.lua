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

  return unit_data.attack_point <= unit_data.anim_cycle
end

function M.IsUnitShootTarget(unit_data, target_data)
  local unit_projectile = functions.GetElementWith(
    target_data.incoming_projectiles,
    nil,
    function(projectile)
      return projectile.caster == all_units.GetUnit(unit_data)
    end)

  return unit_projectile ~= nil
end

function M.IsUnitAttackTarget(unit_data, target_data)
  if functions.GetUnitDistance(unit_data, target_data)
     <= constants.MAX_MELEE_ATTACK_RANGE then

    local unit = all_units.GetUnit(unit_data)

    return M.IsUnitAttack(unit_data)
           and unit:IsFacingLocation(target_data.location, 2)
           and not M.IsAttackDone(unit_data)
  else
    return M.IsUnitShootTarget(unit_data, target_data)
  end
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

function M.GetTotalDamageToUnit(unit_data)
  local result = 0

  local unit_list = M.GetEnemyCreeps(
                         unit_data,
                         constants.MAX_CREEP_ATTACK_RANGE)

  result = result + M.GetTotalDamage(unit_list, unit_data)

  unit_list = M.GetEnemyBuildings(
                         unit_data,
                         constants.MAX_TOWER_ATTACK_RANGE)

  result = result + M.GetTotalDamage(unit_list, unit_data)

  unit_list = M.GetEnemyHeroes(
                         unit_data,
                         constants.MAX_HERO_ATTACK_RANGE)

  result = result + M.GetTotalDamage(unit_list, unit_data)

  unit_list = M.GetAllyHeroes(
                         unit_data,
                         constants.MAX_HERO_ATTACK_RANGE)

  result = result + M.GetTotalDamage(unit_list, unit_data)

  return result
end

function M.GetEnemyHero(unit_data)
  local heroes = M.GetEnemyHeroes(
    unit_data,
    unit_data.attack_range)

  return functions.GetElementWith(
    heroes,
    M.CompareMinHealth,
    function(hero_data)
      return M.IsAttackTargetable(hero_data)
    end)
end

function M.AreUnitsInRadius(unit_data, radius, get_function)
  local units = get_function(unit_data, radius)

  return not functions.IsArrayEmpty(units)
end

function M.IsUnitMoving(unit_data)
  return unit_data.anim_activity == ACTIVITY_RUN
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
