local map = require(
  GetScriptDirectory() .."/database/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

function M.GetNeutralSpot(spot_name)
  return map.MAP[TEAM_NEUTRAL][spot_name]
end

function M.GetUnitAllySpot(unit_data, spot_name)
  return map.MAP[unit_data.team][spot_name]
end

function M.GetAllySpot(spot_name)
  return map.MAP[GetTeam()][spot_name]
end

function M.GetUnitAllySpot(unit_data, spot_name)
  return map.MAP[unit_data.team][spot_name]
end

function M.GetEnemySpot(spot_name)
  return map.MAP[GetOpposingTeam()][spot_name]
end

function M.GetUnitEnemySpot(unit_data, spot_name)
  return map.MAP[functions.GetOpposingTeam(unit_data.team)][spot_name]
end

function M.IsUnitInSpot(unit_data, spot)
  return functions.GetDistance(unit_data.location, spot) <= spot.z
end

function M.IsUnitNearSpot(unit_data, spot)
  return functions.GetDistance(unit_data.location, spot)
         <= constants.NEAR_SPOT_RADIUS
end

function M.IsUnitInEnemyTowerAttackRange(unit_data)
  return M.IsUnitInSpot(
           unit_data,
           M.GetUnitEnemySpot(unit_data, "tower_tier_1_attack"))
end

function M.IsUnitBetweenEnemyTowers(unit_data)
  return M.IsUnitInSpot(
           unit_data,
           M.GetUnitEnemySpot(unit_data, "between_tier_1_tear_2"))
end

-- Provide an access to local functions for unit tests only

return M
