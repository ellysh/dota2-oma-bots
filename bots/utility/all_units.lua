local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local UNIT_LIST = {
  [TEAM_RADIANT] = {},
  [TEAM_DIRE] = {},
}

local UNIT_TYPE = {
  CREEP = {},
  HERO = {},
  TOWER = {},
  UNDEFINED = {}
}

local function GetUnitType(unit)
  if (unit:IsCreep()) then
    return UNIT_TYPE["CREEP"]
  end
  if (unit:IsHero()) then
    return UNIT_TYPE["HERO"]
  end
  if (unit:IsTower()) then
    return UNIT_TYPE["TOWER"]
  end

  return UNIT_TYPE["UNDEFINED"]
end

function M.GetUnitData(unit)
  local result = UNIT_LIST[GetTeam()][tostring(unit)]

  if result == nil then
    result = UNIT_LIST[GetOpposingTeam()][tostring(unit)]
  end

  return result
end

local function GetItems(unit)
  local result = {}

  for i = constants.INVENTORY_START_INDEX, constants.STASH_END_INDEX, 1 do
    table.insert(result, unit:GetItemInSlot(i))
  end

  return result
end

local function AddToUnitList(_, unit)
  UNIT_LIST[GetTeam()][tostring(unit)] = {
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

function M.UpdateUnitList()
  UNIT_LIST[GetTeam()] = {}

  local units = GetUnitList(UNIT_LIST_ALLIES)
  functions.DoWithKeysAndElements(units, AddToUnitList)
end

-- Provide an access to local functions for unit tests only

return M
