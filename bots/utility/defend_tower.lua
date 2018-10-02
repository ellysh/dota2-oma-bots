local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local map = require(
  GetScriptDirectory() .."/utility/map")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local M = {}

---------------------------------

function M.pre_defend_tower()
  return algorithms.IsBotAlive()
         and not env.IS_BOT_LOW_HP
end

---------------------------------

local function GetCreepAttackingTower()
  if env.ALLY_TOWER_DATA == nil then
    return nil end

  local creeps = algorithms.GetEnemyCreeps(
                   env.BOT_DATA,
                   constants.MAX_UNIT_TARGET_RADIUS)

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMaxDamage,
    function(unit_data)
      return algorithms.IsUnitAttackTarget(
               unit_data,
               env.ALLY_TOWER_DATA)
    end)
end

function M.pre_pull_enemy_creep()
  local creep = GetCreepAttackingTower()

  return creep ~= nil
         and env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_HERO_DATA.is_visible
         and env.ALLY_CREEP_FRONT_DATA == nil
         and constants.MAX_CREEPS_HP_PULL < env.ENEMY_CREEPS_HP

         and functions.GetUnitDistance(env.BOT_DATA, creep)
             <= constants.CREEP_MAX_AGRO_RADIUS

         and constants.CREEPS_AGGRO_COOLDOWN
             <= functions.GetDelta(env.LAST_AGGRO_CONTROL, GameTime())
end

function M.pull_enemy_creep()
  env.BOT:Action_AttackUnit(all_units.GetUnit(env.ENEMY_HERO_DATA), true)

  env.LAST_AGGRO_CONTROL = GameTime()
end

---------------------------------

function M.pre_move_enemy_creep()
  local creep = GetCreepAttackingTower()

  return creep ~= nil
         and env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_HERO_DATA.is_visible
         and env.ALLY_CREEP_FRONT_DATA == nil
         and constants.MAX_CREEPS_HP_PULL < env.ENEMY_CREEPS_HP

         and constants.CREEP_MAX_AGRO_RADIUS
             < functions.GetUnitDistance(env.BOT_DATA, creep)
end

function M.move_enemy_creep()
  local creep = GetCreepAttackingTower()

  env.BOT:Action_MoveDirectly(creep.location)

  action_timing.SetNextActionDelay(0.4)
end

---------------------------------

function M.pre_move_safe()
  return env.ALLY_CREEP_FRONT_DATA == nil
         and constants.MAX_CREEPS_HP_PULL < env.ENEMY_CREEPS_HP
         and ((env.ENEMY_CREEP_FRONT_DATA ~= nil

               and (map.IsUnitInSpot(
                      env.ENEMY_CREEP_FRONT_DATA,
                      map.GetAllySpot("between_tier_1_tear_2"))

                    or map.IsUnitInEnemyTowerAttackRange(
                        env.ENEMY_CREEP_FRONT_DATA)))

              or (env.ENEMY_CREEP_BACK_DATA ~= nil

                  and (map.IsUnitInSpot(
                         env.ENEMY_CREEP_BACK_DATA,
                         map.GetAllySpot("between_tier_1_tear_2"))))

                    or map.IsUnitInEnemyTowerAttackRange(
                        env.ENEMY_CREEP_BACK_DATA))
end

function M.move_safe()
  env.BOT:Action_MoveDirectly(env.FOUNTAIN_SPOT)

  action_timing.SetNextActionDelay(0.8)
end

---------------------------------

local function GetCreepAttackingBot()
  local creeps = algorithms.GetEnemyCreeps(
                   env.BOT_DATA,
                   constants.MAX_UNIT_TARGET_RADIUS)

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMaxDamage,
    function(unit_data)
      return algorithms.IsUnitAttackTarget(
               unit_data,
               env.BOT_DATA)
    end)
end

function M.pre_kill_enemy_creep()
  local target = GetCreepAttackingTower()

  if target == nil then
    target = GetCreepAttackingBot()
  end

  return target ~= nil
         and env.ALLY_CREEP_FRONT_DATA == nil
end

function M.kill_enemy_creep()
  local target = GetCreepAttackingTower()

  if target == nil then
    target = GetCreepAttackingBot()
  end

  algorithms.AttackUnit(env.BOT_DATA, target, false)
end

-- Provide an access to local functions for unit tests only

return M
