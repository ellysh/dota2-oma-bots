local map = require(
  GetScriptDirectory() .."/database/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

function M.GetEnemyTowerAttackSpot(unit_data)
  return map.MAP
          [functions.GetOpposingTeam(unit_data.team)]
          ["tower_tier_1_attack"]
end

function M.GetAllyTowerAttackSpot(unit_data)
  return map.MAP[unit_data.team]["tower_tier_1_attack"]
end

local function IsUnitInTowerAttackRange(unit_data, get_function)
  local tower_attack_spot = get_function(unit_data)

  return functions.GetDistance(unit_data.location, tower_attack_spot)
           <= tower_attack_spot.z
end

function M.IsUnitInEnemyTowerAttackRange(unit_data)
  return IsUnitInTowerAttackRange(unit_data, M.GetEnemyTowerAttackSpot)
end

function M.IsUnitInAllyTowerAttackRange(unit_data)
  return IsUnitInTowerAttackRange(unit_data, M.GetAllyTowerAttackSpot)
end

-- Provide an access to local functions for unit tests only

return M
