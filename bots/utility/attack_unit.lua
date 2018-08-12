local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_attack_unit()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and (env.ENEMY_HERO_DATA ~= nil
              or env.BOT_DATA.level < 4)
         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep()
              or M.pre_harras_enemy_hero()
              or M.pre_attack_enemy_creep()
              or M.pre_attack_ally_creep()
              or M.pre_attack_enemy_tower())
end

function M.post_attack_unit()
  return not M.pre_attack_unit()
end

---------------------------------

function M.pre_lasthit_enemy_creep()
  return moves.pre_lasthit_enemy_creep()
end

function M.post_lasthit_enemy_creep()
  return moves.post_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  moves.lasthit_enemy_creep()
end

---------------------------------

function M.pre_deny_ally_creep()
  return moves.pre_deny_ally_creep()
end

function M.post_deny_ally_creep()
  return moves.post_deny_ally_creep()
end

function M.deny_ally_creep()
  moves.deny_ally_creep()
end

--------------------------------

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

function M.pre_harras_enemy_hero()
  return moves.pre_harras_enemy_hero()
end

function M.post_harras_enemy_hero()
  return moves.post_harras_enemy_hero()
end

function M.harras_enemy_hero()
  moves.harras_enemy_hero()
end

--------------------------------

function M.pre_attack_enemy_tower()
  return moves.pre_attack_enemy_tower()
end

function M.post_attack_enemy_tower()
  return moves.post_attack_enemy_tower()
end

function M.attack_enemy_tower()
  moves.attack_enemy_tower()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
