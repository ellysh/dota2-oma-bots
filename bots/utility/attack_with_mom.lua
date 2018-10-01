local constants = require(
  GetScriptDirectory() .."/utility/constants")

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

function M.pre_attack_with_mom()
  return algorithms.IsBotAlive()
         and not env.IS_BOT_LOW_HP
         and algorithms.DoesBotOrCourierHaveItem("item_mask_of_madness")
end

---------------------------------

function M.pre_use_mom()
  return algorithms.IsItemCastable(env.BOT_DATA, "item_mask_of_madness")
         and env.ENEMY_HERO_DISTANCE
             <= constants.MOM_USAGE_FROM_ENEMY_HERO_DISTANCE
end

function M.use_mom()
  env.BOT:Action_UseAbility(
    algorithms.GetItem(env.BOT_DATA, "item_mask_of_madness"))
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()

         and env.BOT:HasModifier(
               "modifier_item_mask_of_madness_berserk")

         and not map.IsUnitInSpot(
                   env.ENEMY_HERO_DATA,
                   map.GetEnemySpot("tower_tier_1_rear"))
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

function M.pre_move_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil

         and env.BOT:HasModifier(
               "modifier_item_mask_of_madness_berserk")

         and env.ENEMY_HERO_DISTANCE
             <= algorithms.GetAttackRange(
                  env.BOT_DATA,
                  env.ENEMY_HERO_DATA,
                  true)
                + constants.MAX_PURSUIT_INC_DISTANCE
end

function M.move_enemy_hero()
  env.BOT:Action_MoveDirectly(env.ENEMY_HERO_DATA.location)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
