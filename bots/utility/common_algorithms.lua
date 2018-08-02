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

function M.CompareMaxHealth(t, a, b)
  return t[b].health < t[a].health
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
           and unit:IsFacingLocation(
                 target_data.location,
                 constants.TURN_TARGET_MAX_DEGREE)
           and not M.IsAttackDone(unit_data)
  else
    return M.IsUnitShootTarget(
             all_units.GetUnit(unit_data),
             target_data,
             target_distance)
  end
end

function M.GetTotalHealth(unit_list)
  if unit_list == nil or #unit_list == 0 then
    return 0 end

  local total_health = 0

  functions.DoWithKeysAndElements(
    unit_list,
    function(_, unit_data)
      if unit_data.is_alive then
        total_health = total_health + unit_data.health
      end
    end)

  return total_health
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
         or unit_data.anim_activity == ACTIVITY_FLAIL
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

  if is_modifier
     and ability:IsFullyCastable()
     and not bot_data.is_silenced then
    bot:Action_UseAbilityOnEntity(ability, unit)
  else
    bot:Action_AttackUnit(unit, true)
  end

  local attack_point = (constants.DROW_RANGER_ATTACK_POINT)
                         * bot_data.seconds_per_attack

  if not bot:IsFacingLocation(
           unit_data.location,
           constants.TURN_TARGET_MAX_DEGREE) then
    attack_point = attack_point + constants.DROW_RANGER_TURN_TIME
  end

  action_timing.SetNextActionDelay(attack_point)
end

function M.BuyItem(item_name)
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem(item_name)

  action_timing.SetNextActionDelay(0.1)
end

function M.DoesTowerProtectEnemyUnit(unit_data)
  local bot_data = M.GetBotData()
  local tower_spot = map.GetEnemySpot(unit_data, "tower_tier_1_attack")

  local bot_tower_distance = functions.GetDistance(
                               bot_data.location,
                               tower_spot)

  return map.IsUnitInEnemyTowerAttackRange(unit_data)
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

function M.IsFocusedByEnemyHero(unit_data)
  local hero_data = M.GetEnemyHero(
                      unit_data,
                      constants.MAX_UNIT_SEARCH_RADIUS)

   return hero_data ~= nil
          and M.IsUnitAttackTarget(hero_data, unit_data)
end

function M.IsFocusedByUnknownUnit(unit_data)
  return M.IsUnitShootTarget(
           nil,
           unit_data,
           constants.MAX_HERO_ATTACK_RANGE)
end

function M.IsFocusedByCreeps(unit_data)
  local creeps = M.GetEnemyCreeps(
                   unit_data,
                   constants.MAX_CREEP_ATTACK_RANGE)

  return nil ~= functions.GetElementWith(
                  creeps,
                  nil,
                  function(creep_data)
                    return M.IsUnitAttackTarget(
                             creep_data,
                             unit_data)
                  end)
end

function M.IsFocusedByTower(unit_data, tower_data)
   return tower_data ~= nil
          and M.IsUnitAttackTarget(
                tower_data,
                unit_data)
end

function M.DoesEnemyCreepAttack(
  unit_data,
  enemy_creep_data,
  ally_creep_data)

  return enemy_creep_data ~= nil

         and ((ally_creep_data ~= nil
               and not functions.IsTargetBetweenUnits(
                         ally_creep_data,
                         unit_data,
                         enemy_creep_data))
              or ally_creep_data == nil)

         and all_units.GetUnit(enemy_creep_data):IsFacingLocation(
               unit_data.location,
               constants.TURN_TARGET_MAX_DEGREE)
end

local function IsEnemyUnitInSpot(unit_data, enemy_hero_data, spot)
  local creeps = M.GetEnemyCreeps(
                   unit_data,
                   constants.MAX_UNIT_TARGET_RADIUS)

  local creep = functions.GetElementWith(
                  creeps,
                  M.CompareMinDistance,
                  function(unit_data)
                    return map.IsUnitInSpot(unit_data, spot)
                  end)

  return (enemy_hero_data ~= nil
          and (functions.GetDistance(enemy_hero_data.location, spot)
                 <= enemy_hero_data.attack_range
               or map.IsUnitInSpot(enemy_hero_data, spot)))
         or creep ~= nil
end

function M.GetSafeSpot(unit_data, enemy_hero_data)
  local hg_spot = map.GetAllySpot(unit_data, "high_ground")
  if not IsEnemyUnitInSpot(unit_data, enemy_hero_data, hg_spot)
     and not map.IsUnitInSpot(unit_data, hg_spot) then
    return hg_spot
  end

  local forest_top_spot = map.GetAllySpot(unit_data, "forest_top")
  local forest_bot_spot = map.GetAllySpot(unit_data, "forest_bot")
  local forest_spot = functions.ternary(
                        functions.GetDistance(
                          unit_data.location,
                          forest_top_spot)
                        < functions.GetDistance(
                          unit_data.location,
                          forest_bot_spot),
                        forest_top_spot,
                        forest_bot_spot)

  if not IsEnemyUnitInSpot(unit_data, enemy_hero_data, forest_spot)
     and not map.IsUnitInSpot(unit_data, forest_spot) then
    return forest_spot
  end

  return map.GetAllySpot(unit_data, "fountain")
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
