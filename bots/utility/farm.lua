local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_farm()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep())
end

function M.post_farm()
  return not M.pre_farm()
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

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
