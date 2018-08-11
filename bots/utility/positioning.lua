local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_positioning()
  return M.pre_move_mid_tower()
         or M.pre_increase_creeps_distance()
         or M.pre_decrease_creeps_distance()
         or M.pre_evasion()
         or M.pre_turn()
end

function M.post_positioning()
  return not M.pre_positioning()
end

---------------------------------

local function AreAllyCreepsInRadius(radius)
  return algorithms.AreUnitsInRadius(
    env.BOT_DATA,
    radius,
    algorithms.GetAllyCreeps)
end

local function AreEnemyCreepsInRadius(radius)
  return algorithms.AreUnitsInRadius(
    env.BOT_DATA,
    radius,
    algorithms.GetEnemyCreeps)
end

function M.pre_move_mid_tower()
  local target_location = map.GetAllySpot(env.BOT_DATA, "high_ground")

  return (not AreAllyCreepsInRadius(constants.MAX_UNIT_SEARCH_RADIUS)
          or functions.GetDistance(
               map.GetAllySpot(env.BOT_DATA, "fountain"),
               env.BOT_DATA.location)
             < constants.BASE_RADIUS)
         and not map.IsUnitInSpot(env.BOT_DATA, target_location)
end

function M.post_move_mid_tower()
  return not M.pre_move_mid_tower()
end

function M.move_mid_tower()
  local target_location = map.GetAllySpot(env.BOT_DATA, "high_ground")

  GetBot():Action_MoveToLocation(target_location)
end

---------------------------------

function M.pre_tp_mid_tower()
  local target_location = map.GetAllySpot(env.BOT_DATA, "high_ground")

  return constants.MIN_TP_BASE_RADIUS
           < functions.GetDistance(target_location, env.BOT_DATA.location)
         and algorithms.IsItemCastable(env.BOT_DATA, "item_tpscroll")
end

function M.post_tp_mid_tower()
  return not M.pre_tp_mid_tower()
end

function M.tp_mid_tower()
  local item = algorithms.GetItem(env.BOT_DATA, "item_tpscroll")

  env.BOT:Action_UseAbilityOnLocation(
    item,
    map.GetAllySpot(env.BOT_DATA, "tp_tower_tier_1"))

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

local function IsEnemyHeroNearCreeps()
  if env.ENEMY_HERO_DATA == nil then
    return false end

  local creeps = algorithms.GetEnemyCreeps(
                       env.BOT_DATA,
                       constants.MAX_UNIT_SEARCH_RADIUS)

  if functions.IsTableEmpty(creeps) then
    return false end

  local creep_data = functions.GetElementWith(
                       creeps,
                       nil,
                       function(unit_data)
                         return constants.CREEP_AGRO_RADIUS
                          < functions.GetUnitDistance(
                              env.ENEMY_HERO_DATA,
                              unit_data)
                       end)


  return creep_data == nil
end

function M.pre_increase_creeps_distance()
  return (AreEnemyCreepsInRadius(constants.MIN_CREEP_DISTANCE)

         or map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)

         or (env.ENEMY_HERO_DATA ~= nil
             and IsEnemyHeroNearCreeps()
             and functions.GetUnitDistance(env.BOT_DATA, env.ENEMY_HERO_DATA)
                   <= env.BOT_DATA.attack_range - 50))

         or (env.ALLY_CREEPS_HP * 3) < env.ENEMY_CREEPS_HP
end

function M.post_increase_creeps_distance()
  return not M.pre_increase_creeps_distance()
end

function M.increase_creeps_distance()
  env.BOT:Action_MoveToLocation(env.SAFE_SPOT)
end

---------------------------------

function M.pre_decrease_creeps_distance()
  local creep_distance = functions.ternary(
                         algorithms.IsUnitLowHp(env.BOT_DATA)
                         or env.BOT_DATA.is_healing,
                         env.BOT_DATA.attack_range,
                         constants.BASE_CREEP_DISTANCE)

  return not AreEnemyCreepsInRadius(creep_distance)
         and not algorithms.DoesEnemyCreepAttack(
                   env.BOT_DATA,
                   env.ENEMY_CREEP_DATA,
                   env.ALLY_CREEP_DATA)
         and (env.ENEMY_CREEP_DATA ~= nil or env.ALLY_CREEP_DATA ~= nil)
         and (not env.BOT_DATA.is_healing
              or env.BOT_DATA.health == env.BOT_DATA.max_health)
end

function M.post_decrease_creeps_distance()
  return not M.pre_decrease_creeps_distance()
end

function M.decrease_creeps_distance()
  local target_data = env.ENEMY_CREEP_DATA

  if target_data == nil then
    target_data = env.ALLY_CREEP_DATA
  end

  GetBot():Action_MoveToLocation(target_data.location)
end

---------------------------------

function M.pre_evasion()
  return algorithms.IsFocusedByCreeps(env.BOT_DATA)
         or algorithms.IsFocusedByTower(
              env.BOT_DATA,
              env.ENEMY_TOWER_DATA)
         or (algorithms.IsFocusedByEnemyHero(env.BOT_DATA)
             and AreEnemyCreepsInRadius(constants.CREEP_AGRO_RADIUS))
         or algorithms.IsFocusedByUnknownUnit(env.BOT_DATA)
end

function M.post_evasion()
  return not M.pre_evasion()
end

function M.evasion()
  env.BOT:Action_MoveToLocation(env.SAFE_SPOT)

  action_timing.SetNextActionDelay(0.8)
end

--------------------------------

function M.pre_turn()
  return AreEnemyCreepsInRadius(env.BOT_DATA.attack_range)
         and env.ENEMY_CREEP_DATA ~= nil
         and not env.BOT:IsFacingLocation(
                   env.ENEMY_CREEP_DATA.location,
                   constants.TURN_TARGET_MAX_DEGREE)
end

function M.post_turn()
  return not M.pre_turn()
end

function M.turn()
  env.BOT:Action_AttackUnit(all_units.GetUnit(env.ENEMY_CREEP_DATA), true)

  action_timing.SetNextActionDelay(constants.DROW_RANGER_TURN_TIME)
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
