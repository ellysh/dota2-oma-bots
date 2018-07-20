local map = require(
  GetScriptDirectory() .."/database/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local function GetEnemyTowerAttackSpot(unit_data)
  return map.MAP
          [functions.GetOpposingTeam(unit_data).team]
          ["tower_tier_1_attack"]
end

function M.IsUnitInEnemyTowerAttackRange(unit_data)
  local tower_attack_spot = GetEnemyTowerAttackSpot(unit_data)

  return functions.GetDistance(unit.data, tower_attack_spot)
           <= tower_attack_spot.z
end

-- Provide an access to local functions for unit tests only

return M
