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

function M.GetAllyHgSpot(unit_data)
  return map.MAP[unit_data.team]["high_ground"]
end

function M.GetAllySpot(unit_data, spot_name)
  return map.MAP[unit_data.team][spot_name]
end

function M.IsUnitInSpot(unit_data, spot)
  return functions.GetDistance(unit_data.location, spot) <= spot.z
end

function M.IsUnitInEnemyTowerAttackRange(unit_data)
  return M.IsUnitInSpot(unit_data, M.GetEnemyTowerAttackSpot(unit_data))
end

-- Provide an access to local functions for unit tests only

return M
