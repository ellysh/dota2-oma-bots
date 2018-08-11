local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

M.BOT_DATA = {}
M.ENEMY_CREEP_DATA = {}
M.ENEMY_HERO_DATA = {}
M.ALLY_CREEP_DATA = {}
M.ENEMY_TOWER_DATA = {}
M.ALLY_CREEPS_HP = 0
M.ENEMY_CREEPS_HP = 0

local function GetClosestCreep(radius, get_function)
  local creeps = get_function(
    BOT_DATA,
    radius)

  return functions.GetElementWith(
    creeps,
    common_algorithms.CompareMinDistance,
    function(unit_data)
      return not common_algorithms.IsUnitLowHp(unit_data)
    end)
end

function M.UpdateVariables()
  M.BOT = GetBot()

  M.BOT_DATA = common_algorithms.GetBotData()

  M.ENEMY_HERO_DATA = common_algorithms.GetEnemyHero(
                        BOT_DATA,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  M.ENEMY_CREEP_DATA = GetClosestCreep(
                         constants.MAX_UNIT_SEARCH_RADIUS,
                         common_algorithms.GetEnemyCreeps)

  M.ALLY_CREEP_DATA = GetClosestCreep(
                        constants.MAX_UNIT_SEARCH_RADIUS,
                        common_algorithms.GetAllyCreeps)

  M.ENEMY_TOWER_DATA = common_algorithms.GetEnemyBuildings(
                         BOT_DATA,
                         constants.MAX_UNIT_SEARCH_RADIUS)[1]

  M.ALLY_CREEPS_HP = common_algorithms.GetTotalHealth(
                       common_algorithms.GetAllyCreeps(
                         BOT_DATA,
                         constants.MAX_UNIT_SEARCH_RADIUS))

  M.ENEMY_CREEPS_HP = common_algorithms.GetTotalHealth(
                        common_algorithms.GetEnemyCreeps(
                          BOT_DATA,
                          constants.MAX_UNIT_SEARCH_RADIUS))
end

-- Provide an access to local functions for unit tests only

return M
