local M = {}

local UNIT_LIST = {
  [TEAM_RADIANT] = {},
  [TEAM_DIRE] = {},
}

local function DoWithKeysAndElements(list, do_function)
  for key, element in pairs(list) do
    do_function(key, element)
  end
end

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

local function AddToUnitList(_, unit)
  UNIT_LIST[GetTeam()][tostring(unit)] = {
    name = unit:GetUnitName(),
    location = unit:GetLocation(),
    health = unit:GetHealth(),
    mana = unit:GetMana(),
    is_alive = unit:IsAlive(),
    type = GetUnitType(unit),
    attack_target = unit:GetTarget(),
    team = unit:GetTeam()
  }
end

function M.UpdateUnitList()
  UNIT_LIST[GetTeam()] = {}

  local units = GetUnitList(UNIT_LIST_ALLIES)
  DoWithKeysAndElements(units, AddToUnitList)
end

-- Provide an access to local functions for unit tests only

return M
