local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local UNIT_TYPE = {
  CREEP = {},
  HERO = {},
  BULDING = {},
}

local UNIT_LIST = {
  [TEAM_RADIANT] = {
    [UNIT_TYPE["CREEP"]] = {},
    [UNIT_TYPE["HERO"]] = {},
    [UNIT_TYPE["BULDING"]] = {},
  },
  [TEAM_DIRE] = {
    [UNIT_TYPE["CREEP"]] = {},
    [UNIT_TYPE["HERO"]] = {},
    [UNIT_TYPE["BULDING"]] = {},
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

local function GetOpposingTeam(team)
  local OPPOSING_TEAM = {
    [TEAM_RADIANT] = TEAM_DIRE,
    [TEAM_DIRE] = TEAM_RADIANT,
  }

  return OPPOSING_TEAM[team]
end

local function AddUnit(unit, type, team)
  UNIT_LIST[team][type][tostring(unit)] = {
    handle = unit,
    name = unit:GetUnitName(),
    location = unit:GetLocation(),
    health = unit:GetHealth(),
    mana = unit:GetMana(),
    is_alive = unit:IsAlive(),
    attack_target = unit:GetTarget(),
    team = unit:GetTeam(),
    items = GetItems(unit),
  }
end

local function AddAllyCreep(_, unit)
  AddUnit(unit, UNIT_TYPE["CREEP"], GetTeam())
end

local function AddEnemyCreep(_, unit)
  AddUnit(unit, UNIT_TYPE["CREEP"], GetOpposingTeam(GetTeam()))
end

local function ClearUnitList()
  -- TODO: Track the history of units parameters here
  UNIT_LIST = {
    [TEAM_RADIANT] = {
      [UNIT_TYPE["CREEP"]] = {},
      [UNIT_TYPE["HERO"]] = {},
      [UNIT_TYPE["BULDING"]] = {},
    },
    [TEAM_DIRE] = {
      [UNIT_TYPE["CREEP"]] = {},
      [UNIT_TYPE["HERO"]] = {},
      [UNIT_TYPE["BULDING"]] = {},
    }
  }
end

function M.UpdateUnitList()
  ClearUnitList()

  local units = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
  functions.DoWithKeysAndElements(units, AddAllyCreep)

  local units = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
  functions.DoWithKeysAndElements(units, AddEnemyCreep)
end

----------------------------------
-- Functions to retrieve UNIT_LIST
----------------------------------

function M.GetUnitData(unit)
  return UNIT_LIST[unit:GetTeam()][tostring(unit)]
end

function M.GetEnemyUnitsData(unit)
  return UNIT_LIST[GetOpposingTeam(unit:GetTeam())]
end

function M.GetAllyUnitsData(unit)
  return UNIT_LIST[unit:GetTeam()]
end

-- Provide an access to local functions for unit tests only

return M
