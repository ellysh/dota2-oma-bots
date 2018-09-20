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

function M.CompareMaxDamage(t, a, b)
  return t[b].attack_damage < t[a].attack_damage
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

function M.IsUnitCriticalHp(unit_data)
  return unit_data.health <= constants.UNIT_CRITICAL_HEALTH
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

function M.GetEnemyTowerDistance(unit_data)
  return functions.GetDistance(
           unit_data.location,
           map.GetEnemySpot("tower_tier_1_attack"))
end

function M.DoesTowerProtectUnit(unit_data)
  local bot_data = M.GetBotData()
  local tower_spot = map.GetEnemySpot("tower_tier_1_attack")

  local bot_tower_distance = M.GetEnemyTowerDistance(bot_data)

  return bot_tower_distance <= constants.CREEP_MAX_AGRO_RADIUS
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
  return M.IsUnitShootTarget(
           nil,
           unit_data)
end

local function GetRangedIncomingDamage(target_data, time_limit)
  local incoming_damage = 0

  functions.DoWithKeysAndElements(
    target_data.incoming_projectiles,
    function(_, projectile)
      if projectile.caster == nil then
        return end

      local unit_data = all_units.GetUnitData(projectile.caster)

      local time_to_projectile = functions.GetDistance(
                                   projectile.location,
                                   target_data.location)
                                 / unit_data.projectile_speed

      if time_to_projectile < time_limit then
        incoming_damage = incoming_damage + unit_data.attack_damage
      end
    end)

  return incoming_damage
end

local function GetMeleeIncomingDamage(target_data, time_limit)
  local unit_list = GetUnitsInRadius(
                      target_data,
                      constants.MELEE_ATTACK_RANGE,
                      all_units.GetEnemyCreepsData)

  local incoming_damage = 0

  functions.DoWithKeysAndElements(
    unit_list,
    function(_, unit_data)
      if not M.IsUnitAttack(unit_data)
         or not functions.IsFacingLocation(
               unit_data,
               target_data.location,
               constants.TURN_TARGET_MAX_DEGREE) then
        return
      end

      local time_to_damage = 0

      if M.IsAttackDone(unit_data) then
        time_to_damage = ((1 - unit_data.anim_cycle)
          + unit_data.anim_attack_point) * unit_data.seconds_per_attack
      else
        time_to_damage = (unit_data.anim_attack_point
          - unit_data.anim_cycle) * unit_data.seconds_per_attack
      end

      if time_to_damage < time_limit then
        incoming_damage = incoming_damage + unit_data.attack_damage
      end
    end)

  return incoming_damage
end

local function GetIncomingDamage(target_data, time_limit)
  return GetRangedIncomingDamage(target_data, time_limit)
         + GetMeleeIncomingDamage(target_data, time_limit)
end

function M.IsLastHitTarget(unit_data, target_data)
  local time_to_attack = (functions.GetUnitDistance(
                            unit_data,
                            target_data)
                          / unit_data.projectile_speed)
                          + unit_data.seconds_per_attack

  local incoming_damage = GetIncomingDamage(target_data, time_to_attack)

  local health_when_attack = target_data.health - (incoming_damage
    * functions.GetDamageMultiplier(target_data.armor))

  return health_when_attack
         <= (unit_data.attack_damage
             * functions.GetDamageMultiplier(target_data.armor))
end

function M.IsFocusedByCreeps(unit_data)
  local creeps = M.GetEnemyCreeps(
                   unit_data,
                   constants.MAX_UNIT_TARGET_RADIUS)

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

local function IsTargetNearSpot(unit_data, enemy_units, spot)
  local enemy_unit = functions.GetElementWith(
                       enemy_units,
                       nil,
                       function(target_data)
                       return functions.GetDistance(
                                target_data.location,
                                spot)
                              <= M.GetAttackRange(
                                   target_data,
                                   unit_data,
                                   true)

                              or map.IsUnitInSpot(target_data, spot)
                       end)


  return enemy_unit ~= nil
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

local function IsSpotSafe(spot, unit_data, enemy_units)
  return not IsTargetNearSpot(unit_data, enemy_units, spot)

         and not (map.IsUnitInSpot(unit_data, spot)
                  and (M.IsFocusedByEnemyHero(unit_data)
                       or M.IsFocusedByUnknownUnit(unit_data)
                       or M.IsFocusedByCreeps(unit_data)))
end

local function GetClosestSafeSpot(
  spot1,
  spot2,
  unit_data,
  enemy_units)

  local is_spot1_safe = IsSpotSafe(spot1, unit_data, enemy_units)
  local is_spot2_safe = IsSpotSafe(spot2, unit_data, enemy_units)

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

function M.GetSafeSpot(unit_data, enemy_units)
  if M.IsItemCastable(unit_data, "item_flask")
     or M.IsItemCastable(unit_data, "item_tango")
     or unit_data.is_healing then

    local hg_spot = map.GetUnitAllySpot(unit_data, "high_ground")

    local forest_spot = GetClosestSafeSpot(
                          map.GetUnitAllySpot(unit_data, "forest_top"),
                          map.GetUnitAllySpot(unit_data, "forest_bot"),
                          unit_data,
                          enemy_units)

    if IsSpotSafe(hg_spot, unit_data, enemy_units)
       and forest_spot ~= nil then

      return hg_spot
    end

    if forest_spot ~= nil then
      return forest_spot end
  end

  local forest_back_spot = GetClosestSafeSpot(
                            map.GetUnitAllySpot(
                              unit_data,
                              "forest_back_top"),
                            map.GetUnitAllySpot(
                              unit_data,
                              "forest_back_bot"),
                            unit_data,
                            enemy_units)

  if forest_back_spot ~= nil then
    return forest_back_spot end

  local forest_deep_spot = GetClosestSafeSpot(
                            map.GetUnitAllySpot(
                              unit_data,
                              "forest_deep_top"),
                            map.GetUnitAllySpot(
                              unit_data,
                              "forest_deep_bot"),
                            unit_data,
                            enemy_units)

  if forest_deep_spot ~= nil then
    return forest_deep_spot end

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

function M.GetCreepWith(
  bot_data,
  side,
  compare_function,
  validate_function)

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
    compare_function,
    function(unit_data)
      return M.IsAttackTargetable(unit_data)
             and not M.IsCourierUnit(unit_data)
             and (validate_function == nil
                  or validate_function(unit_data))
    end)
end

function M.GetPreLastHitCreep(bot_data, side)
  return M.GetCreepWith(
           bot_data,
           side,
           M.CompareMinHealth,
           function(unit_data)
             local incoming_damage = M.GetTotalIncomingDamage(unit_data)
             local total_damage = bot_data.attack_damage
                                  + (incoming_damage * 1.3)

             return 0 < incoming_damage
                    and unit_data.health < total_damage
           end)
end

function M.GetLastHitCreep(bot_data, side)
  return M.GetCreepWith(
           bot_data,
           side,
           M.CompareMinHealth,
           function(unit_data)
             return M.IsLastHitTarget(bot_data, unit_data)
           end)
end

function M.GetAttackRange(unit_data, target_data, use_buffer_range)
  local buffer_range = functions.ternary(
                         use_buffer_range,
                         constants.MOTION_BUFFER_RANGE,
                         0)

  return unit_data.attack_range
         + unit_data.collision_size
         + target_data.collision_size
         + buffer_range
end

function M.IsTargetInAttackRange(unit_data, target_data, use_buffer_range)
  if unit_data == nil or target_data == nil then
    return false end

  return functions.GetUnitDistance(unit_data, target_data)
         <= M.GetAttackRange(unit_data, target_data, use_buffer_range)
end

function M.IsFirstWave()
  return DotaTime() < constants.TIME_FIRST_WAVE_MEET
end

function M.IsUnitAttack(unit_data)
  return unit_data.anim_activity == ACTIVITY_ATTACK
         or unit_data.anim_activity == ACTIVITY_ATTACK2
end

function M.IsAttackDone(unit_data)
  return unit_data.anim_attack_point <= unit_data.anim_cycle
end

-- We should pass unit handle to this function for detecting a "nil" caster
function M.IsUnitShootTarget(unit, target_data)
  local unit_projectile = functions.GetElementWith(
    target_data.incoming_projectiles,
    nil,
    function(projectile)
      return projectile.caster == unit
    end)

  return unit_projectile ~= nil
end

function M.IsUnitAttackTarget(unit_data, target_data)
  if unit_data.attack_range <= constants.MAX_MELEE_ATTACK_RANGE then

    return M.IsUnitAttack(unit_data)
           and functions.IsFacingLocation(
                 unit_data,
                 target_data.location,
                 constants.TURN_TARGET_MAX_DEGREE)
           and functions.GetUnitDistance(unit_data, target_data)
               <= unit_data.attack_range + constants.MOTION_BUFFER_RANGE
  else
    return M.IsUnitShootTarget(
             all_units.GetUnit(unit_data),
             target_data)
  end
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_UpdateUnitList = all_units.UpdateUnitList

return M
