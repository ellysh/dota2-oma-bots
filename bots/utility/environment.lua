local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

M.BOT_DATA = {}
M.ENEMY_CREEP_DATA = {}
M.ENEMY_HERO_DATA = {}
M.ALLY_CREEP_DATA = {}
M.ENEMY_TOWER_DATA = {}
M.ALLY_CREEPS_HP = 0
M.ENEMY_CREEPS_HP = 0
M.SAFE_SPOT = {}
M.FOUNTAIN_SPOT = {}
M.DOES_TOWER_PROTECT_ENEMY = false

local function GetClosestCreep(radius, get_function)
  local creeps = get_function(
    M.BOT_DATA,
    radius)

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMinDistance,
    function(unit_data)
      return not algorithms.IsUnitLowHp(unit_data)
    end)
end

function M.UpdateVariables()
  M.BOT = GetBot()

  M.BOT_DATA = algorithms.GetBotData()

  M.ENEMY_HERO_DATA = algorithms.GetEnemyHero(
                        M.BOT_DATA,
                        constants.MAX_UNIT_SEARCH_RADIUS)

  M.ENEMY_CREEP_DATA = GetClosestCreep(
                         constants.MAX_UNIT_SEARCH_RADIUS,
                         algorithms.GetEnemyCreeps)

  M.ALLY_CREEP_DATA = GetClosestCreep(
                        constants.MAX_UNIT_SEARCH_RADIUS,
                        algorithms.GetAllyCreeps)

  M.ENEMY_TOWER_DATA = algorithms.GetEnemyBuildings(
                         M.BOT_DATA,
                         constants.MAX_UNIT_SEARCH_RADIUS)[1]

  M.ALLY_CREEPS_HP = algorithms.GetTotalHealth(
                       algorithms.GetAllyCreeps(
                         M.BOT_DATA,
                         constants.MAX_UNIT_SEARCH_RADIUS))

  M.ENEMY_CREEPS_HP = algorithms.GetTotalHealth(
                        algorithms.GetEnemyCreeps(
                          M.BOT_DATA,
                          constants.MAX_UNIT_SEARCH_RADIUS))

  M.SAFE_SPOT = algorithms.GetSafeSpot(M.BOT_DATA, ENEMY_HERO_DATA)

  M.FOUNTAIN_SPOT = map.GetAllySpot(M.BOT_DATA, "fountain")

  if M.ENEMY_HERO_DATA ~= nil then
    M.DOES_TOWER_PROTECT_ENEMY =
      algorithms.DoesTowerProtectEnemyUnit(
        M.ENEMY_HERO_DATA)
  end
end

-- Provide an access to local functions for unit tests only

return M
