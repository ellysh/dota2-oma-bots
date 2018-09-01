local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_defend_tower()
  return algorithms.IsBotAlive()
         and not env.IS_BOT_LOW_HP

         and (M.pre_attack_enemy_creep()
              or M.pre_attack_enemy_hero())
end

function M.post_defend_tower()
  return not M.pre_defend_tower()
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
      return all_units.IsUnitAttackTarget(
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

function M.post_attack_enemy_creep()
  return not M.pre_attack_enemy_creep()
end

function M.attack_enemy_creep()
  local creep = GetCreepAttackingTower()

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

--------------------------------

function M.pre_attack_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and env.ALLY_TOWER_DATA ~= nil
         and all_units.IsUnitAttackTarget(
               env.ENEMY_HERO_DATA,
               env.ALLY_TOWER_DATA)
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
