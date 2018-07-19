local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

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

function M.IsUnitShootTarget(unit_data, target_data, target_distance)
  local unit_projectile = functions.GetElementWith(
    target_data.incoming_projectiles,
    nil,
    function(projectile)
      return projectile.caster == all_units.GetUnit(unit_data)
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
    return M.IsUnitShootTarget(unit_data, target_data, target_distance)
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

  return not functions.IsArrayEmpty(units)
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

function M.AttackUnit(bot_data, unit_data)
  local bot = GetBot()
  local unit = all_units.GetUnit(unit_data)

  bot:Action_AttackUnit(unit, true)

  local attack_point = constants.DROW_RANGER_ATTACK_POINT / bot_data.attack_speed

  action_timing.SetNextActionDelay(attack_point)
end

function M.DoesTowerProtectEnemyUnit(unit_data)
  local bot_data = M.GetBotData()
  local tower_data = M.GetEnemyBuildings(
                           bot_data,
                           constants.MAX_UNIT_SEARCH_RADIUS)[1]

  if tower_data == nil then
    return false end

  local bot_tower_distance = functions.GetUnitDistance(
                               bot_data,
                               tower_data)

  return bot_tower_distance < constants.MAX_TOWER_ATTACK_RANGE
         or bot_tower_distance
              < functions.GetUnitDistance(bot_data, unit_data)
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
