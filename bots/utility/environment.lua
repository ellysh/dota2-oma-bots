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
M.ALLY_CREEP_FRONT_DATA = {}
M.ALLY_CREEP_BACK_DATA = {}
M.ENEMY_TOWER_DATA = {}
M.ALLY_CREEPS_HP = 0
M.ENEMY_CREEPS_HP = 0
M.SAFE_SPOT = {}
M.FOUNTAIN_SPOT = {}
M.DOES_TOWER_PROTECT_ENEMY = false
M.IS_FOCUSED_BY_CREEPS = false
M.IS_FOCUSED_BY_ENEMY_HERO = false
M.IS_FOCUSED_BY_UNKNOWN_UNIT = false
M.IS_FOCUSED_BY_TOWER = false
M.IS_BASE_RECOVERY = false

local function GetClosestCreep(radius, get_function, direction)
  local creeps = get_function(
    M.BOT_DATA,
    radius)

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMinDistance,
    function(unit_data)
      return not algorithms.IsUnitLowHp(unit_data)
             and algorithms.IsAttackTargetable(unit_data)
             and not algorithms.IsCourierUnit(unit_data)
             and (direction == constants.DIRECTION["ANY"]
                  or (direction == constants.DIRECTION["FRONT"]
                      and algorithms.IsFrontUnit(M.BOT_DATA, unit_data)
                      and algorithms.IsAliveFrontUnit(unit_data))
                  or (direction == constants.DIRECTION["BACK"]
                      and not algorithms.IsFrontUnit(
                                M.BOT_DATA,
                                unit_data)))
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
                         algorithms.GetEnemyCreeps,
                         constants.DIRECTION["ANY"])

  M.ALLY_CREEP_FRONT_DATA = GetClosestCreep(
                              constants.MAX_UNIT_SEARCH_RADIUS,
                              algorithms.GetAllyCreeps,
                              constants.DIRECTION["FRONT"])

  M.ALLY_CREEP_BACK_DATA = GetClosestCreep(
                             constants.MAX_UNIT_SEARCH_RADIUS,
                             algorithms.GetAllyCreeps,
                             constants.DIRECTION["BACK"])

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

  M.IS_FOCUSED_BY_CREEPS = algorithms.IsFocusedByCreeps(M.BOT_DATA)

  M.IS_FOCUSED_BY_ENEMY_HERO = algorithms.IsFocusedByEnemyHero(
                                 M.BOT_DATA)

  M.IS_FOCUSED_BY_UNKNOWN_UNIT = algorithms.IsFocusedByUnknownUnit(
                                   M.BOT_DATA)

  M.IS_FOCUSED_BY_TOWER = algorithms.IsFocusedByTower(M.BOT_DATA)

  M.IS_BASE_RECOVERY = functions.GetRate(
                         M.BOT_DATA.health,
                         M.BOT_DATA.max_health)
                       < constants.UNIT_HALF_HEALTH_LEVEL

                       and functions.GetDistance(
                             M.FOUNTAIN_SPOT,
                             M.BOT_DATA.location)
                           <= constants.BASE_RADIUS
end

-- Provide an access to local functions for unit tests only

return M
