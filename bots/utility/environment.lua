local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

M.BOT = {}
M.BOT_DATA = {}
M.IS_BOT_LOW_HP = false
M.IS_ENEMY_HERO_LOW_HP = false
M.ENEMY_CREEP_FRONT_DATA = {}
M.ENEMY_CREEP_BACK_DATA = {}
M.ENEMY_HERO_DATA = {}
M.ENEMY_HERO_DISTANCE = 0
M.ALLY_CREEP_FRONT_DATA = {}
M.ALLY_CREEP_BACK_DATA = {}
M.ENEMY_TOWER_DATA = {}
M.ENEMY_TOWER_DISTANCE = 0
M.ALLY_TOWER_DATA = {}
M.PRE_LAST_HIT_ENEMY_CREEP = {}
M.PRE_LAST_HIT_ALLY_CREEP = {}
M.LAST_HIT_ENEMY_CREEP = {}
M.LAST_HIT_ALLY_CREEP = {}
M.ALLY_CREEPS_HP = 0
M.ENEMY_CREEPS_HP = 0
M.SAFE_SPOT = {}
M.FARM_SPOT = {}
M.FOUNTAIN_SPOT = {}
M.DOES_TOWER_PROTECT_ENEMY = false
M.IS_FOCUSED_BY_CREEPS = false
M.IS_FOCUSED_BY_ENEMY_HERO = false
M.IS_FOCUSED_BY_UNKNOWN_UNIT = false
M.IS_FOCUSED_BY_TOWER = false
M.IS_BASE_RECOVERY = false
M.LAST_AGGRO_CONTROL = 0
M.DOES_BOT_HAVE_ADVANTAGE = false
M.DOES_ENEMY_HERO_HAVE_ADVANTAGE = false

local function GetClosestCreep(radius, get_function, direction)
  local creeps = get_function(
    M.BOT_DATA,
    radius)

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMinUnitDistance,
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

local function IsUnitRelativeLowHp(unit_data, enemy_hero_data)
  return unit_data ~= nil
         and (algorithms.IsUnitLowHp(unit_data)

              or (enemy_hero_data ~= nil
                  and functions.GetRate(
                        unit_data.health,
                        unit_data.max_health)
                      < constants.UNIT_MODERATE_HEALTH_LEVEL
                  and (algorithms.IsBiggerThan(
                         enemy_hero_data.health,
                         unit_data.health,
                         unit_data.max_health / 2)
                       or algorithms.IsBiggerThan(
                         enemy_hero_data.attack_damage * 3,
                         unit_data.health,
                         0))))
end

local function DoesUnitHaveAdvantage(unit_data, target_data)
  return unit_data ~= nil
         and target_data ~= nil
         and (algorithms.IsBiggerThan(
                unit_data.attack_damage,
                target_data.attack_damage,
                50)
              or algorithms.IsBiggerThan(
                   unit_data.health,
                   target_data.health,
                   300)
              or algorithms.IsBiggerThan(
                   unit_data.speed,
                   target_data.speed,
                   40)
              or algorithms.IsBiggerThan(
                   unit_data.attack_speed,
                   target_data.attack_speed,
                   20)
              or algorithms.IsBiggerThan(
                   unit_data.attack_range,
                   target_data.attack_range,
                   100)

              or algorithms.HasModifier(
                   unit_data,
                   "modifier_item_mask_of_madness_berserk")

              or (algorithms.IsItemPresent(
                    unit_data,
                    "item_mask_of_madness")
                  and not algorithms.IsItemPresent(
                            target_data,
                            "item_mask_of_madness")))
end

function M.UpdateVariables()
  M.BOT = GetBot()

  M.BOT_DATA = algorithms.GetBotData()

  M.ENEMY_HERO_DATA = algorithms.GetLastSeenEnemyHero(M.BOT_DATA)

  M.IS_BOT_LOW_HP = IsUnitRelativeLowHp(M.BOT_DATA, M.ENEMY_HERO_DATA)

  M.IS_ENEMY_HERO_LOW_HP = IsUnitRelativeLowHp(
                             M.ENEMY_HERO_DATA,
                             M.BOT_DATA)

  M.ENEMY_CREEP_FRONT_DATA = GetClosestCreep(
                               constants.MAX_UNIT_SEARCH_RADIUS,
                               algorithms.GetEnemyCreeps,
                               constants.DIRECTION["FRONT"])

  M.ENEMY_CREEP_BACK_DATA = GetClosestCreep(
                               constants.MAX_UNIT_SEARCH_RADIUS,
                               algorithms.GetEnemyCreeps,
                               constants.DIRECTION["BACK"])

  M.ALLY_CREEP_FRONT_DATA = GetClosestCreep(
                              constants.MAX_UNIT_SEARCH_RADIUS,
                              algorithms.GetAllyCreeps,
                              constants.DIRECTION["FRONT"])

  M.ALLY_CREEP_BACK_DATA = GetClosestCreep(
                             constants.MAX_UNIT_SEARCH_RADIUS,
                             algorithms.GetAllyCreeps,
                             constants.DIRECTION["BACK"])

  M.ENEMY_TOWER_DATA = algorithms.GetEnemyTier1Tower(M.BOT_DATA)

  if M.ENEMY_TOWER_DATA ~= nil then
    M.ENEMY_TOWER_DISTANCE = functions.GetUnitDistance(
                               M.BOT_DATA,
                               M.ENEMY_TOWER_DATA)
  end

  M.ALLY_TOWER_DATA = algorithms.GetAllyTier1Tower(M.BOT_DATA)

  M.PRE_LAST_HIT_ENEMY_CREEP = algorithms.GetPreLastHitCreep(
                                 M.BOT_DATA,
                                 constants.SIDE["ENEMY"])

  M.PRE_LAST_HIT_ALLY_CREEP = algorithms.GetPreLastHitCreep(
                                M.BOT_DATA,
                                constants.SIDE["ALLY"])

  M.LAST_HIT_ENEMY_CREEP = algorithms.GetLastHitCreep(
                             M.BOT_DATA,
                             constants.SIDE["ENEMY"])

  M.LAST_HIT_ALLY_CREEP = algorithms.GetLastHitCreep(
                             M.BOT_DATA,
                             constants.SIDE["ALLY"])

  M.ALLY_CREEPS_HP = algorithms.GetTotalHealth(
                       algorithms.GetAllyCreeps(
                         M.BOT_DATA,
                         constants.MAX_UNIT_SEARCH_RADIUS))

  M.ENEMY_CREEPS_HP = algorithms.GetTotalHealth(
                        algorithms.GetEnemyCreeps(
                          M.BOT_DATA,
                          constants.MAX_UNIT_SEARCH_RADIUS))

  M.SAFE_SPOT = algorithms.GetSafeSpot(M.BOT_DATA,
                                       {M.ENEMY_HERO_DATA,
                                        M.ENEMY_CREEP_FRONT_DATA,
                                        M.ENEMY_CREEP_BACK_DATA})

  M.FARM_SPOT = algorithms.GetFarmSpot(M.BOT_DATA,
                                       {M.ENEMY_HERO_DATA,
                                        M.ENEMY_CREEP_FRONT_DATA,
                                        M.ENEMY_CREEP_BACK_DATA})

  M.FOUNTAIN_SPOT = map.GetAllySpot("fountain")

  if M.ENEMY_HERO_DATA ~= nil then
    M.DOES_TOWER_PROTECT_ENEMY =
      algorithms.DoesTowerProtectUnit(M.ENEMY_HERO_DATA)

    M.ENEMY_HERO_DISTANCE = functions.GetUnitDistance(
                              M.BOT_DATA,
                              M.ENEMY_HERO_DATA)
  end

  M.DOES_BOT_HAVE_ADVANTAGE = DoesUnitHaveAdvantage(
                                M.BOT_DATA,
                                M.ENEMY_HERO_DATA)

  M.DOES_ENEMY_HERO_HAVE_ADVANTAGE = DoesUnitHaveAdvantage(
                                       M.ENEMY_HERO_DATA,
                                       M.BOT_DATA)

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
