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

local M = {}

---------------------------------

function M.pre_keep_equilibrium()
  return algorithms.IsBotAlive()
         and not env.IS_BOT_LOW_HP
         and not algorithms.HasLevelForAggression(env.BOT_DATA)
         and env.ENEMY_CREEP_BACK_DATA == nil

         and env.PRE_LAST_HIT_ENEMY_CREEP == nil
         and env.PRE_LAST_HIT_ALLY_CREEP == nil

         and not algorithms.IsTargetInAttackRange(
                   env.ENEMY_HERO_DATA,
                   env.BOT_DATA,
                   true)
end

---------------------------------

function M.pre_attack_enemy_creep()
  return constants.MAX_CREEPS_HP_DELTA
           < (env.ENEMY_CREEPS_HP - env.ALLY_CREEPS_HP)
         and moves.pre_attack_enemy_creep()
end

function M.attack_enemy_creep()
  moves.attack_enemy_creep()
end

--------------------------------

function M.pre_attack_ally_creep()
  return constants.MAX_CREEPS_HP_DELTA
           < (env.ALLY_CREEPS_HP - env.ENEMY_CREEPS_HP)
         and moves.pre_attack_ally_creep()
end

function M.attack_ally_creep()
  moves.attack_ally_creep()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
