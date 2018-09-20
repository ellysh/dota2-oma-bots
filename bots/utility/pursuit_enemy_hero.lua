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

local LAST_SEEN_ENEMY_HERO_DATA = nil

local function GetEnemyHero()
  return functions.ternary(
           env.ENEMY_HERO_DATA ~= nil,
           env.ENEMY_HERO_DATA,
           LAST_SEEN_ENEMY_HERO_DATA)
end

function M.pre_pursuit_enemy_hero()
  LAST_SEEN_ENEMY_HERO_DATA = algorithms.GetLastSeenEnemyHero()

  local enemy_hero_data = GetEnemyHero()

  return enemy_hero_data ~= nil

         and algorithms.IsBotAlive()
         and (algorithms.IsUnitLowHp(enemy_hero_data)
              or (enemy_hero_data.is_flask_healing
                  and algorithms.IsBiggerThan(
                        env.BOT_DATA.health,
                        enemy_hero_data.health,
                        100)))

         and not env.IS_BOT_LOW_HP

         and (not env.IS_FOCUSED_BY_TOWER
              or 6 < env.BOT_DATA.level)

         and not map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot("tower_tier_1_rear"))
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

function M.pre_move_enemy_hero()
  local enemy_hero_data = GetEnemyHero()

  return enemy_hero_data ~= nil

         and functions.GetUnitDistance(
                env.BOT_DATA,
                enemy_hero_data)
              <= algorithms.GetAttackRange(
                   env.BOT_DATA,
                   enemy_hero_data,
                   true)
                 + constants.MAX_PURSUIT_INC_DISTANCE

         and not env.DOES_TOWER_PROTECT_ENEMY
         and not algorithms.IsUnitMoving(env.BOT_DATA)
end

function M.move_enemy_hero()
  env.BOT:Action_MoveDirectly(GetEnemyHero().location)
end

---------------------------------

function M.pre_use_silence()
  return moves.pre_use_silence()
end

function M.use_silence()
  moves.use_silence()
end

---------------------------------

return M
