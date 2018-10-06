local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local UNIT_TYPE = {
  CREEP = {},
  HERO = {},
  BUILDING = {},
}

local UNIT_LIST = {
  [TEAM_RADIANT] = {
    [UNIT_TYPE["CREEP"]] = {},
    [UNIT_TYPE["HERO"]] = {},
    [UNIT_TYPE["BUILDING"]] = {},
  },
  [TEAM_DIRE] = {
    [UNIT_TYPE["CREEP"]] = {},
    [UNIT_TYPE["HERO"]] = {},
    [UNIT_TYPE["BUILDING"]] = {},
  },
}

local CURRENT_GAME_TIME = 0

-------------------------------
-- Functions to fill UNIT_LIST
-------------------------------

local function GetItems(unit)
  local result = {}

  for i = constants.INVENTORY_START_INDEX, constants.STASH_END_INDEX, 1 do
    table.insert(result, unit:GetItemInSlot(i))
  end

  return result
end

local function IsHealing(unit)
  return unit:HasModifier("modifier_flask_healing")
         or unit:HasModifier("modifier_tango_heal")
         or unit:HasModifier("modifier_fountain_aura_buff")
         or unit:HasModifier("modifier_filler_heal") -- shrine heal
end

local function IsUnitCasting(unit)
  return unit:IsChanneling()
         or unit:IsCastingAbility()
end

local function AddUnit(unit, unit_type, team)
  UNIT_LIST[team][unit_type][tostring(unit)] = {
    timestamp = CURRENT_GAME_TIME,
    handle = unit,
    type = unit_type,
    name = unit:GetUnitName(),
    location = unit:GetLocation(),
    health = unit:GetHealth(),
    max_health = unit:GetMaxHealth(),
    mana = unit:GetMana(),
    max_mana = unit:GetMaxMana(),
    armor = unit:GetArmor(),
    -- This field is always true because AddUnit works for
    -- GetUnitList returned units.
    -- is_alive = unit:IsAlive(),
    is_invulnerable = unit:IsInvulnerable(),
    is_illusion = unit:IsIllusion(),
    attack_damage = unit:GetAttackDamage(),
    attack_range = unit:GetAttackRange(),
    anim_attack_point = unit:GetAttackPoint(),
    attack_speed = unit:GetAttackSpeed(),
    seconds_per_attack = unit:GetSecondsPerAttack(),
    anim_activity = unit:GetAnimActivity(),
    anim_cycle = unit:GetAnimCycle(),
    team = unit:GetTeam(),
    items = GetItems(unit),
    incoming_projectiles = unit:GetIncomingTrackingProjectiles(),
    is_healing = IsHealing(unit),
    is_flask_healing = unit:HasModifier("modifier_flask_healing");
    nearby_trees = unit:GetNearbyTrees(constants.TREE_SEARCH_RADIUS),
    is_casting = IsUnitCasting(unit),
    is_channeling = unit:IsChanneling(),
    is_silenced = unit:IsSilenced(),
    gold = unit:GetGold(),
    stash_value = unit:GetStashValue(),
    level = unit:GetLevel(),
    ability_points = unit:GetAbilityPoints(),
    height_level = GetHeightLevel(unit:GetLocation()),
    speed = unit:GetCurrentMovementSpeed(),
    facing = unit:GetFacing(),
    is_visible = true,
    projectile_speed = unit:GetAttackProjectileSpeed(),
    collision_size = unit:GetBoundingRadius(),
    incoming_damage_from_creeps = 0,
    incoming_damage_from_heroes = 0,
    incoming_damage_from_towers = 0,
    player_id = unit:GetPlayerID(),
    -- attack_target
    -- last_attack_time
  }
end

local function AddAllyCreep(_, unit)
  AddUnit(unit, UNIT_TYPE["CREEP"], GetTeam())
end

local function AddAllyHero(_, unit)
  AddUnit(unit, UNIT_TYPE["HERO"], GetTeam())
end

local function AddAllyBuilding(_, unit)
  AddUnit(unit, UNIT_TYPE["BUILDING"], GetTeam())
end

local function AddEnemyCreep(_, unit)
  AddUnit(unit, UNIT_TYPE["CREEP"], GetOpposingTeam())
end

local function AddEnemyHero(_, unit)
  AddUnit(unit, UNIT_TYPE["HERO"], GetOpposingTeam())
end

local function AddEnemyBuilding(_, unit)
  AddUnit(unit, UNIT_TYPE["BUILDING"], GetOpposingTeam())
end

local function GetBotData()
  local heroes = UNIT_LIST[GetTeam()][UNIT_TYPE["HERO"]]

  return functions.GetElementWith(
           heroes,
           nil,
           function(unit_data)
             return unit_data.name ~= "npc_dota_hero_shadow_shaman"
           end)
end

local function InvalidateUnit(_, unit_data)
  local age = CURRENT_GAME_TIME - unit_data.timestamp

  if 6 <= age then
    M.InvalidateUnit(unit_data)
  elseif 0 < age then
    unit_data.is_visible = false
  end
end

local function InvalidateDeprecatedUnits()
  functions.DoWithKeysAndElements(
    UNIT_LIST[GetTeam()][UNIT_TYPE["CREEP"]],
    InvalidateUnit)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetTeam()][UNIT_TYPE["BUILDING"]],
    InvalidateUnit)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["CREEP"]],
    InvalidateUnit)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["HERO"]],
    InvalidateUnit)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["BUILDING"]],
    InvalidateUnit)
end

local function AddTargetIncomingDamage(unit_data, target_data)
  if unit_data.type == UNIT_TYPE["CREEP"] then
    target_data.incoming_damage_from_creeps =
      target_data.incoming_damage_from_creeps + unit_data.attack_damage
  elseif unit_data.type == UNIT_TYPE["HERO"] then
    target_data.incoming_damage_from_heroes =
      target_data.incoming_damage_from_heroes + unit_data.attack_damage
  elseif unit_data.type == UNIT_TYPE["BUILDING"] then
    target_data.incoming_damage_from_towers =
      target_data.incoming_damage_from_towers + unit_data.attack_damage
  end
end

local function UpdateUnitAttackTarget(_, unit_data)
  if not unit_data.is_visible
     or (unit_data.last_attack_time ~= nil
         and (CURRENT_GAME_TIME - unit_data.last_attack_time)
              < (unit_data.seconds_per_attack
                 + constants.LAST_ATTACK_TIME_CORRECTION)) then

    return
  end

  local target = nil
  local api_target = unit_data.handle:GetAttackTarget()

  if api_target ~= nil then
    target = M.GetUnitData(api_target)
  end

  local prev_target = functions.ternary(
                        unit_data.attack_target ~= nil
                        and unit_data.last_attack_time ~= nil,
                        unit_data.attack_target,
                        nil)

  if target == nil
     and unit_data.last_attack_time ~= nil
     and unit_data.seconds_per_attack
         < (CURRENT_GAME_TIME - unit_data.last_attack_time) then

    unit_data.last_attack_time = 0
    unit_data.attack_target = nil
  elseif target ~= nil then

    unit_data.last_attack_time = CURRENT_GAME_TIME
    unit_data.attack_target = target
    AddTargetIncomingDamage(unit_data, target)
  elseif prev_target ~= nil then
    AddTargetIncomingDamage(unit_data, prev_target)
  end
end

local function UpdateAttackTarget()
  functions.DoWithKeysAndElements(
    UNIT_LIST[GetTeam()][UNIT_TYPE["CREEP"]],
    UpdateUnitAttackTarget)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetTeam()][UNIT_TYPE["HERO"]],
    UpdateUnitAttackTarget)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetTeam()][UNIT_TYPE["BUILDING"]],
    UpdateUnitAttackTarget)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["CREEP"]],
    UpdateUnitAttackTarget)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["HERO"]],
    UpdateUnitAttackTarget)

  functions.DoWithKeysAndElements(
    UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["BUILDING"]],
    UpdateUnitAttackTarget)
end

function M.UpdateUnitList()
  CURRENT_GAME_TIME = GameTime()

  local units = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
  functions.DoWithKeysAndElements(units, AddAllyCreep)

  units = GetUnitList(UNIT_LIST_ALLIED_HEROES)
  functions.DoWithKeysAndElements(units, AddAllyHero)

  units = GetUnitList(UNIT_LIST_ALLIED_BUILDINGS)
  functions.DoWithKeysAndElements(units, AddAllyBuilding)

  units = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
  functions.DoWithKeysAndElements(units, AddEnemyCreep)

  units = GetUnitList(UNIT_LIST_ENEMY_HEROES)
  functions.DoWithKeysAndElements(units, AddEnemyHero)

  units = GetUnitList(UNIT_LIST_ENEMY_BUILDINGS)
  functions.DoWithKeysAndElements(units, AddEnemyBuilding)

  units = { GetCourier(0) }
  if units[1] == nil then
    return end

  functions.DoWithKeysAndElements(units, AddAllyCreep)

  InvalidateDeprecatedUnits()

  UpdateAttackTarget()
end

----------------------------------
-- Functions to retrieve UNIT_LIST
----------------------------------

local function GetUnitType(unit)
  if (unit:IsCreep()) then
    return UNIT_TYPE["CREEP"]
  end
  if (unit:IsHero()) then
    return UNIT_TYPE["HERO"]
  end
  if (unit:IsTower()) then
    return UNIT_TYPE["BUILDING"]
  end

  return UNIT_TYPE["CREEP"]
end

function M.GetUnitData(unit)
  if unit:IsNull() then
    return nil
  else
    return UNIT_LIST[unit:GetTeam()][GetUnitType(unit)][tostring(unit)]
  end
end

function M.GetUnit(unit_data)
  return unit_data.handle
end

function M.GetEnemyCreepsData(unit_data)
  return UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["CREEP"]]
end

function M.GetEnemyHeroesData(unit_data)
  return UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["HERO"]]
end

function M.GetEnemyBuildingsData(unit_data)
  return UNIT_LIST[GetOpposingTeam()][UNIT_TYPE["BUILDING"]]
end

function M.GetAllyCreepsData(unit_data)
  return UNIT_LIST[unit_data.team][UNIT_TYPE["CREEP"]]
end

function M.GetAllyHeroesData(unit_data)
  return UNIT_LIST[unit_data.team][UNIT_TYPE["HERO"]]
end

function M.GetAllyBuildingsData(unit_data)
  return UNIT_LIST[unit_data.team][UNIT_TYPE["BUILDING"]]
end

function M.InvalidateUnit(unit_data)
  -- We should store the unit details because they will be cleared by
  -- the functions.ClearTable call

  local invalid_team = unit_data.team
  local invalid_type = unit_data.type
  local invalid_handle = tostring(unit_data.handle)

  functions.ClearTable(
    UNIT_LIST[invalid_team][invalid_type][invalid_handle])

  UNIT_LIST[invalid_team][invalid_type][invalid_handle] = nil
end

-- Provide an access to local functions for unit tests only

return M
