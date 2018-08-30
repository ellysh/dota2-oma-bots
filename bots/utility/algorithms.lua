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
         and unit_data.is_visible
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
             and check_unit_data.is_visible
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

local function IsProjectileClose(unit_data, target_data, bot_data)
  if bot_data == nil then
    return true
  end

  local unit_projectile = functions.GetElementWith(
    target_data.incoming_projectiles,
    nil,
    function(projectile)
      if projectile.caster ~= unit_data.handler then
        return false
      end

      local time_unit_projectile = functions.GetDistance(
                                     projectile.location,
                                     target_data.location)
                                   / unit_data.projectile_speed

      local time_bot_projectile = (functions.GetDistance(
                                      bot_data.location,
                                      target_data.location)
                                   / bot_data.projectile_speed)
                                  + bot_data.seconds_per_attack

      return time_unit_projectile < time_bot_projectile
    end)

  return unit_projectile ~= nil
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

function M.GetTotalIncomingDamage(unit_data)
  return unit_data.incoming_damage_from_creeps
         + unit_data.incoming_damage_from_heroes
         + unit_data.incoming_damage_from_towers
end

function M.IsUnitLowHp(unit_data)
  local unit_health = unit_data.health
                      - M.GetTotalIncomingDamage(unit_data)

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

  if not functions.IsFacingLocation(
           bot_data,
           unit_data.location,
           constants.TURN_TARGET_MAX_DEGREE) then
    attack_point = attack_point + constants.DROW_RANGER_TURN_TIME
  end

  action_timing.SetNextActionDelay(attack_point)
end

function M.BuyItem(item_name)
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem(item_name)

  action_timing.SetNextActionDelay(0.05)
end

function M.DoesTowerProtectUnit(unit_data)
  local bot_data = M.GetBotData()
  local tower_spot = map.GetEnemySpot("tower_tier_1_attack")

  local bot_tower_distance = functions.GetDistance(
                               bot_data.location,
                               tower_spot)

  return bot_tower_distance < constants.CREEP_AGRO_RADIUS
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
   return 0 < unit_data.incoming_damage_from_heroes
end

function M.IsFocusedByUnknownUnit(unit_data)
  return all_units.IsUnitShootTarget(
           nil,
           unit_data,
           constants.MAX_HERO_ATTACK_RANGE)
end

function M.IsLastHitTarget(unit_data, target_data)
  local incoming_damage = unit_data.attack_damage
                            + M.GetTotalIncomingDamage(target_data)

  if (100 < unit_data.attack_damage or 2 < target_data.armor) then
    incoming_damage = incoming_damage
                      * functions.GetDamageMultiplier(target_data.armor)
  end

  return target_data.health < incoming_damage
end

function M.IsFocusedByCreeps(unit_data)
  local creeps = M.GetEnemyCreeps(
                   unit_data,
                   constants.MAX_CREEP_ATTACK_RANGE)

  return nil ~= functions.GetElementWith(
                  creeps,
                  nil,
                  function(creep_data)
                    return not M.IsLastHitTarget(unit_data, creep_data)
                           and creep_data.attack_target == unit_data
                  end)
end

function M.IsFocusedByTower(unit_data)
  return 0 < unit_data.incoming_damage_from_towers
end

local function IsEnemyUnitNearSpot(unit_data, enemy_hero_data, spot)
  local creeps = M.GetEnemyCreeps(
                   unit_data,
                   constants.MAX_UNIT_TARGET_RADIUS)

  local creep = functions.GetElementWith(
                  creeps,
                  M.CompareMinDistance,
                  function(unit_data)
                    return map.IsUnitNearSpot(unit_data, spot)
                  end)

  return (enemy_hero_data ~= nil
          and (functions.GetDistance(enemy_hero_data.location, spot)
                 <= enemy_hero_data.attack_range
               or map.IsUnitNearSpot(enemy_hero_data, spot)))
         or creep ~= nil
end

function M.GetUnitDistanceFromFountain(unit_data)
  return functions.GetDistance(
           map.GetUnitAllySpot(unit_data, "fountain"),
           unit_data.location)
end

function M.GetDistanceFromFountain(unit_data, location)
  return functions.GetDistance(
           map.GetUnitAllySpot(unit_data, "fountain"),
           location)
end

-- Check if an unit stays ahead of the bot
function M.IsFrontUnit(bot_data, unit_data)
  return M.GetUnitDistanceFromFountain(bot_data)
         < M.GetUnitDistanceFromFountain(unit_data)
end

local function IsSpotSafe(spot, unit_data, enemy_hero_data)
  return not (
         IsEnemyUnitNearSpot(unit_data, enemy_hero_data, spot)

         or (enemy_hero_data ~= nil
             and functions.GetUnitDistance(unit_data, enemy_hero_data)
                   < constants.MAX_HERO_ATTACK_RANGE
             and 20 < (M.GetDistanceFromFountain(unit_data, spot)
                        - M.GetUnitDistanceFromFountain(unit_data)))

         or (map.IsUnitInSpot(unit_data, spot)
             and (M.IsFocusedByEnemyHero(unit_data)
                  or M.IsFocusedByUnknownUnit(unit_data)
                  or M.IsFocusedByCreeps(unit_data))))
end

local function GetClosestSafeSpot(
  spot1,
  spot2,
  unit_data,
  enemy_hero_data)

  local is_spot1_safe = IsSpotSafe(spot1, unit_data, enemy_hero_data)
  local is_spot2_safe = IsSpotSafe(spot2, unit_data, enemy_hero_data)

  if is_spot1_safe and is_spot2_safe then
    return functions.ternary(
             functions.GetDistance(unit_data.location, spot1)
               < functions.GetDistance(unit_data.location, spot2),
             spot1,
             spot2)
  else
    return nil
  end
end

function M.GetSafeSpot(unit_data, enemy_hero_data)
  local hg_spot = map.GetUnitAllySpot(unit_data, "high_ground")

  local forest_spot = GetClosestSafeSpot(
                        map.GetUnitAllySpot(unit_data, "forest_top"),
                        map.GetUnitAllySpot(unit_data, "forest_bot"),
                        unit_data,
                        enemy_hero_data)

  if IsSpotSafe(hg_spot, unit_data, enemy_hero_data)
     and forest_spot ~= nil then

    return hg_spot
  end

  if forest_spot ~= nil then
    return forest_spot end

  local forest_back_spot = GetClosestSafeSpot(
                            map.GetUnitAllySpot(
                              unit_data,
                              "forest_back_top"),
                            map.GetUnitAllySpot(
                              unit_data,
                              "forest_back_bot"),
                            unit_data,
                            enemy_hero_data)

  if forest_back_spot ~= nil then
    return forest_back_spot end

  return map.GetUnitAllySpot(unit_data, "fountain")
end

function M.IsItemCastable(unit_data, item_name)
  return M.IsItemPresent(unit_data, item_name)
         and M.IsItemInInventory(unit_data, item_name)
         and M.GetItem(unit_data, item_name):IsFullyCastable()
end

function M.IsRangedUnit(unit_data)
  return constants.MAX_MELEE_ATTACK_RANGE < unit_data.attack_range
end

function M.AreEnemyCreepsInRadius(unit_data, radius)
  return M.AreUnitsInRadius(unit_data, radius, M.GetEnemyCreeps)
end

function M.IsCourierUnit(unit_data)
  return unit_data.name == "npc_dota_courier"
         or unit_data.name == "npc_dota_flying_courier"
end

function M.IsAliveFrontUnit(unit_data)
  return constants.UNIT_HALF_HEALTH_LEVEL
         < functions.GetRate(unit_data.health, unit_data.max_health)
         or not map.IsUnitInEnemyTowerAttackRange(unit_data)
end

function M.AreAllyCreepsInRadius(unit_data, radius, direction)
  local creeps = M.GetAllyCreeps(unit_data, radius)

  return nil ~= functions.GetElementWith(
    creeps,
    nil,
    function(creep)
      return not M.IsCourierUnit(creep)
             and (direction == constants.DIRECTION["ANY"]
                  or (direction == constants.DIRECTION["FRONT"]
                      and M.IsFrontUnit(unit_data, creep)
                      and M.IsAliveFrontUnit(creep))
                  or (direction == constants.DIRECTION["BACK"]
                      and not M.IsFrontUnit(unit_data, creep)))
    end)
end

function M.DoesEnemyTowerAttackAllyCreep(unit_data, tower_data)
  if tower_data == nil then
    return end

  local creeps = M.GetAllyCreeps(
                       unit_data,
                       constants.MAX_UNIT_SEARCH_RADIUS)

  return nil ~= functions.GetElementWith(
                  creeps,
                  nil,
                  function(creep)
                    return 1.5 * tower_data.attack_damage < creep.health
                           and tower_data.attack_target == creep
                  end)
end

function M.IsBotAlive()
  return GetBot():IsAlive()
end

local function GetCreepWith(bot_data, side, validate_function)
  local creeps = functions.ternary(
    side == constants.SIDE["ENEMY"],
    M.GetEnemyCreeps(
      bot_data,
      constants.MAX_UNIT_TARGET_RADIUS),
    M.GetAllyCreeps(
      bot_data,
      constants.MAX_UNIT_TARGET_RADIUS))

  return functions.GetElementWith(
    creeps,
    M.CompareMinHealth,
    function(unit_data)
      return M.IsAttackTargetable(unit_data)
             and not M.IsCourierUnit(unit_data)
             and validate_function(unit_data)
    end)
end

local function GetPreLastHitMultiplier(bot_data)
  return functions.ternary(bot_data.attack_damage < 100, 2.0, 1.5)
end

function M.GetPreLastHitCreep(bot_data, side)
  return GetCreepWith(
           bot_data,
           side,
           function(unit_data)
             local incoming_damage = M.GetTotalIncomingDamage(unit_data)
             local total_damage = (GetPreLastHitMultiplier(bot_data)
                                   * bot_data.attack_damage)
                                  + incoming_damage

             return 0 < incoming_damage
                    and unit_data.health < total_damage
           end)
end

function M.GetLastHitCreep(bot_data, side)
  return GetCreepWith(
           bot_data,
           side,
           function(unit_data)
             return M.IsLastHitTarget(bot_data, unit_data)
           end)
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
