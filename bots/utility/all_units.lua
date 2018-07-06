local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local UNIT_LIST = {
  [TEAM_RADIANT] = {},
  [TEAM_DIRE] = {},
}

M.UNIT_TYPE = {
  CREEP = {},
  HERO = {},
  TOWER = {},
  UNDEFINED = {}
}

-------------------------------
-- Functions to fill UNIT_LIST
-------------------------------

local function GetUnitType(unit)
  if (unit:IsCreep()) then
    return M.UNIT_TYPE["CREEP"]
  end
  if (unit:IsHero()) then
    return M.UNIT_TYPE["HERO"]
  end
  if (unit:IsTower()) then
    return M.UNIT_TYPE["TOWER"]
  end

  return M.UNIT_TYPE["UNDEFINED"]
end

local function GetItems(unit)
  local result = {}

  for i = constants.INVENTORY_START_INDEX, constants.STASH_END_INDEX, 1 do
    table.insert(result, unit:GetItemInSlot(i))
  end

  return result
end

local function GetOpposingTeam(unit)
  local OPPOSING_TEAM = {
    [TEAM_RADIANT] = TEAM_DIRE,
    [TEAM_DIRE] = TEAM_RADIANT,
  }

  return OPPOSING_TEAM[unit:GetTeam()]
end

local function AddUnit(unit, team)
  UNIT_LIST[team][tostring(unit)] = {
    handle = unit,
    name = unit:GetUnitName(),
    location = unit:GetLocation(),
    health = unit:GetHealth(),
    mana = unit:GetMana(),
    is_alive = unit:IsAlive(),
    type = GetUnitType(unit),
    attack_target = unit:GetTarget(),
    team = unit:GetTeam(),
    items = GetItems(unit),
  }
end

local function AddAllyUnit(_, unit)
  AddUnit(unit, GetTeam())
end

local function AddEnemyUnit(_, unit)
  AddUnit(unit, GetOpposingTeam(GetTeam()))
end

function M.UpdateUnitList()
  -- TODO: Track the history of units parameters here
  UNIT_LIST[GetTeam()] = {}

  local units = GetUnitList(UNIT_LIST_ALLIES)
  functions.DoWithKeysAndElements(units, AddAllyUnit)

  local units = GetUnitList(UNIT_LIST_ENEMIES)
  functions.DoWithKeysAndElements(units, AddEnemyUnit)
end

----------------------------------
-- Functions to retrieve UNIT_LIST
----------------------------------

function M.GetUnitData(unit)
  local result = UNIT_LIST[GetTeam()][tostring(unit)]

  if result == nil then
    result = UNIT_LIST[GetOpposingTeam()][tostring(unit)]
  end

  return result
end

function M.GetEnemyUnitsData(unit)
  return UNIT_LIST[GetOpposingTeam(unit)]
end

function M.GetAllyUnitsData(unit)
  return UNIT_LIST[unit:GetTeam()]
end

-- Provide an access to local functions for unit tests only

return M
