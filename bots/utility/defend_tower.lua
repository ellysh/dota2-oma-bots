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

function M.pre_attack_enemy_creep()
  local creep = GetCreepAttackingTower()

  return creep ~= nil
         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_UNKNOWN_UNIT
end

function M.attack_enemy_creep()
  local creep = GetCreepAttackingTower()

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

---------------------------------

local function GetEnemyUnitInTowerAttackRange()
  local creep = algorithms.GetCreepWith(
           env.BOT_DATA,
           constants.SIDE["ENEMY"],
           algorithms.CompareMinHealth,
           map.IsUnitInEnemyTowerAttackRange)

  return algorithms.GetCreepWith(
           env.BOT_DATA,
           constants.SIDE["ENEMY"],
           algorithms.CompareMinHealth,
           map.IsUnitInEnemyTowerAttackRange)
end

function M.pre_kill_enemy_creep()
  return constants.MAX_CREEPS_HP_DELTA
         < (env.ENEMY_CREEPS_HP - env.ALLY_CREEPS_HP)

         and (env.ENEMY_HERO_DATA == nil
              or map.IsUnitInEnemyTowerAttackRange(env.ENEMY_HERO_DATA))

         and GetEnemyUnitInTowerAttackRange() ~= nil
end

function M.kill_enemy_creep()
  local creep = GetEnemyUnitInTowerAttackRange()

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
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
  moves.attack_enemy_hero(true)
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
