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

function M.pre_pursuit_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and not env.IS_BOT_LOW_HP
         and algorithms.HasLevelForAggression(env.BOT_DATA)
         and algorithms.IsBotAlive()
         and algorithms.IsItemCastable(env.BOT_DATA, "item_flask")

         and (env.IS_ENEMY_HERO_LOW_HP

              or (env.ENEMY_HERO_DATA.is_flask_healing

                  and algorithms.IsBiggerThan(
                        env.BOT_DATA.health,
                        env.ENEMY_HERO_DATA.health,
                        100)))

         and (not env.DOES_TOWER_PROTECT_ENEMY
              or algorithms.IsTowerDiveReasonable(
                   env.BOT_DATA,
                   env.ENEMY_HERO_DATA))

         and not map.IsUnitInSpot(
                   env.ENEMY_HERO_DATA,
                   map.GetEnemySpot("tower_tier_1_rear_deep"))
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
  return moves.pre_move_enemy_hero()
end

function M.move_enemy_hero()
  local enemy_high_ground = map.GetEnemySpot("high_ground")

  if not env.ENEMY_HERO_DATA.is_visible
     and map.IsUnitInSpot(env.ENEMY_HERO_DATA, enemy_high_ground)
     and not IsLocationVisible(enemy_high_ground) then

    env.BOT:Action_MoveDirectly(enemy_high_ground)
  else
    moves.move_enemy_hero()
  end
end

---------------------------------

return M
