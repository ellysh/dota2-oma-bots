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
  return not algorithms.IsUnitLowHp(env.BOT_DATA)

         and (M.pre_attack_enemy_creep()
              or M.pre_attack_ally_creep())

         and (env.ENEMY_HERO_DATA == nil
              or env.ENEMY_HERO_DATA.attack_range
                 < functions.GetUnitDistance(
                     env.BOT_DATA,
                     env.ENEMY_HERO_DATA))
end

function M.post_keep_equilibrium()
  return not M.pre_keep_equilibrium()
end

---------------------------------

function M.pre_attack_enemy_creep()
  return constants.MAX_CREEPS_HP_DELTA
           < (env.ENEMY_CREEPS_HP - env.ALLY_CREEPS_HP)
         and moves.pre_attack_enemy_creep()
end

function M.post_attack_enemy_creep()
  return moves.post_attack_enemy_creep()
end

function M.attack_enemy_creep()
  moves.attack_enemy_creep()
end

--------------------------------

function M.pre_attack_ally_creep()
  return moves.pre_attack_ally_creep()
end

function M.post_attack_ally_creep()
  return moves.post_attack_ally_creep()
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
