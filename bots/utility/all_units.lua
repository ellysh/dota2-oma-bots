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

local function AddUnit(unit, type, team)
  UNIT_LIST[team][type][tostring(unit)] = {
    handle = unit,
    name = unit:GetUnitName(),
    location = unit:GetLocation(),
    health = unit:GetHealth(),
    max_health = unit:GetMaxHealth(),
    mana = unit:GetMana(),
    max_mana = unit:GetMaxMana(),
    armor = unit:GetArmor(),
    is_alive = unit:IsAlive(),
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
    nearby_trees = unit:GetNearbyTrees(constants.TREE_SEARCH_RADIUS),
    is_casting = IsUnitCasting(unit),
    gold = unit:GetGold(),
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
  AddUnit(unit, UNIT_TYPE["CREEP"], functions.GetOpposingTeam(GetTeam()))
end

local function AddEnemyHero(_, unit)
  AddUnit(unit, UNIT_TYPE["HERO"], functions.GetOpposingTeam(GetTeam()))
end

local function AddEnemyBuilding(_, unit)
  AddUnit(unit, UNIT_TYPE["BUILDING"], functions.GetOpposingTeam(GetTeam()))
end

local function ClearUnitList()
  -- TODO: Track the history of units parameters here
  UNIT_LIST = {
    [TEAM_RADIANT] = {
      [UNIT_TYPE["CREEP"]] = {},
      [UNIT_TYPE["HERO"]] = {},
      [UNIT_TYPE["BUILDING"]] = {},
    },
    [TEAM_DIRE] = {
      [UNIT_TYPE["CREEP"]] = {},
      [UNIT_TYPE["HERO"]] = {},
      [UNIT_TYPE["BUILDING"]] = {},
    }
  }
end

function M.UpdateUnitList()
  ClearUnitList()

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
  return UNIT_LIST[unit:GetTeam()][GetUnitType(unit)][tostring(unit)]
end

function M.GetUnit(unit_data)
  return unit_data.handle
end

function M.GetEnemyCreepsData(unit_data)
  return UNIT_LIST[functions.GetOpposingTeam(unit_data.team)][UNIT_TYPE["CREEP"]]
end

function M.GetEnemyHeroesData(unit_data)
  return UNIT_LIST[functions.GetOpposingTeam(unit_data.team)][UNIT_TYPE["HERO"]]
end

function M.GetEnemyBuildingsData(unit_data)
  return UNIT_LIST[functions.GetOpposingTeam(unit_data.team)][UNIT_TYPE["BUILDING"]]
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

-- Provide an access to local functions for unit tests only

return M
