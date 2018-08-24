local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_kill_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and algorithms.IsBotAlive()
         and algorithms.IsUnitLowHp(env.ENEMY_HERO_DATA)

         and not algorithms.IsUnitLowHp(env.BOT_DATA)

         and (not env.IS_FOCUSED_BY_TOWER
              or 6 < env.BOT_DATA.level)

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot(env.BOT_DATA, "tower_tier_1_rear"))
end

function M.post_kill_enemy_hero()
  return not M.pre_kill_enemy_hero()
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()
end

function M.post_attack_enemy_hero()
  return moves.post_attack_enemy_hero()
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

function M.pre_move_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and not env.DOES_TOWER_PROTECT_ENEMY
         and not algorithms.IsUnitMoving(env.BOT_DATA)
end

function M.post_move_enemy_hero()
  return not M.pre_move_enemy_hero()
end

function M.move_enemy_hero()
  env.BOT:Action_MoveDirectly(env.ENEMY_HERO_DATA.location)
end

---------------------------------

function M.pre_use_silence()
  return moves.pre_use_silence()
end

function M.post_use_silence()
  return moves.post_use_silence()
end

function M.use_silence()
  moves.use_silence()
end

---------------------------------

return M
