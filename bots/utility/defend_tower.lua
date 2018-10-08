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
                   constants.MAX_UNIT_SEARCH_RADIUS)

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
             <= constants.CREEP_MAX_AGGRO_RADIUS

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
         and env.ALLY_CREEP_FRONT_DATA == nil
         and algorithms.HasLevelForAggression(env.BOT_DATA)
         and constants.MAX_CREEPS_HP_PULL < env.ENEMY_CREEPS_HP

         and constants.CREEP_MAX_AGGRO_RADIUS
             < functions.GetUnitDistance(env.BOT_DATA, creep)
end

function M.move_enemy_creep()
  local creep = GetCreepAttackingTower()

  env.BOT:Action_MoveDirectly(creep.location)

  action_timing.SetNextActionDelay(0.4)
end

---------------------------------

function M.pre_move_safe()
  local agressive_creep = GetCreepAttackingTower()

  local closest_enemy_creep = functions.ternary(
                              env.ENEMY_CREEP_FRONT_DATA ~= nil,
                              env.ENEMY_CREEP_FRONT_DATA,
                              env.ENEMY_CREEP_BACK_DATA)


  return agressive_creep == nil
         and env.ALLY_CREEP_FRONT_DATA == nil
         and constants.MAX_CREEPS_HP_PULL < env.ENEMY_CREEPS_HP
         and (closest_enemy_creep ~= nil

               and (map.IsUnitBetweenEnemyTowers(
                      closest_enemy_creep)

                    or map.IsUnitInEnemyTowerAttackRange(
                        closest_enemy_creep)))
end

function M.move_safe()
  env.BOT:Action_MoveDirectly(env.FOUNTAIN_SPOT)

  action_timing.SetNextActionDelay(0.4)
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
             and functions.GetUnitDistance(
                   unit_data,
                   env.ALLY_TOWER_DATA)
                 <= constants.MIN_CREEP_DISTANCE
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

---------------------------------

function M.pre_use_silence()
  return moves.pre_use_silence()
         and env.ALLY_TOWER_DATA ~= nil
         and algorithms.IsUnitAttackTarget(
               env.ENEMY_HERO_DATA,
               env.ALLY_TOWER_DATA)
end

function M.use_silence()
  moves.use_silence()
end

--------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()
         and env.ALLY_TOWER_DATA ~= nil
         and algorithms.IsUnitAttackTarget(
               env.ENEMY_HERO_DATA,
               env.ALLY_TOWER_DATA)
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

--------------------------------

-- Provide an access to local functions for unit tests only

return M
