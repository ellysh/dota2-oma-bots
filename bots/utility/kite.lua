local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_kite()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and M.pre_harras_enemy_hero()
end

function M.post_kite()
  return not M.pre_kite()
end

---------------------------------

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

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
