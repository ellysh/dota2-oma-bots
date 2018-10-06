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

function M.pre_use_frost_arrow()
  local required_mana =
    env.BOT:GetAbilityByName("drow_ranger_frost_arrows"):GetManaCost()
    + algorithms.GetItem(env.BOT_DATA, "item_mask_of_madness"):GetManaCost()

  return moves.pre_attack_enemy_hero()

         and not algorithms.HasModifier(
                   env.ENEMY_HERO_DATA,
                   "modifier_drow_ranger_frost_arrows_slow")

         and not algorithms.HasModifier(
               env.BOT_DATA,
               "modifier_item_mask_of_madness_berserk")

         and (env.ENEMY_HERO_DATA ~= nil
               and env.ENEMY_HERO_DATA.is_visible
               and env.ENEMY_HERO_DISTANCE
                   <= constants.MOM_USAGE_FROM_ENEMY_HERO_DISTANCE)

         and not map.IsUnitInSpot(
                   env.ENEMY_HERO_DATA,
                   map.GetEnemySpot("tower_tier_1_rear_deep"))

         and required_mana <= env.BOT_DATA.mana
end

function M.use_frost_arrow()
  moves.attack_enemy_hero()
end

---------------------------------

function M.pre_use_mom()
  return algorithms.IsItemCastable(env.BOT_DATA, "item_mask_of_madness")
         and ((env.ENEMY_HERO_DATA ~= nil
               and env.ENEMY_HERO_DATA.is_visible
               and env.ENEMY_HERO_DISTANCE
                   <= constants.MOM_USAGE_FROM_ENEMY_HERO_DISTANCE)

              or (env.ENEMY_TOWER_DATA ~= nil
                  and env.ENEMY_TOWER_DISTANCE
                      <= algorithms.GetAttackRange(
                           env.BOT_DATA,
                           env.ENEMY_TOWER_DATA,
                           false)))
end

function M.use_mom()
  env.BOT:Action_UseAbility(
    algorithms.GetItem(env.BOT_DATA, "item_mask_of_madness"))
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()

         and algorithms.HasModifier(
               env.BOT_DATA,
               "modifier_item_mask_of_madness_berserk")

         and not map.IsUnitInSpot(
                   env.ENEMY_HERO_DATA,
                   map.GetEnemySpot("tower_tier_1_rear_deep"))
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.pre_attack_enemy_tower()
  return env.ENEMY_TOWER_DATA ~= nil
         and env.ENEMY_TOWER_DISTANCE
             <= algorithms.GetAttackRange(
                  env.BOT_DATA,
                  env.ENEMY_TOWER_DATA,
                  false)
         and algorithms.HasModifier(
               env.BOT_DATA,
               "modifier_item_mask_of_madness_berserk")
end

function M.attack_enemy_tower()
  algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_TOWER_DATA, false)
end

--------------------------------

function M.pre_kill_enemy_creep()
  local creep = algorithms.GetCreepWith(
                  env.BOT_DATA,
                  constants.SIDE["ENEMY"],
                  algorithms.CompareMinHealth,
                  nil)

  return creep ~= nil

         and algorithms.HasModifier(
               env.BOT_DATA,
               "modifier_item_mask_of_madness_berserk")

         and not algorithms.DoesTowerProtectUnit(creep)
end

function M.kill_enemy_creep()
  local creep = algorithms.GetCreepWith(
                  env.BOT_DATA,
                  constants.SIDE["ENEMY"],
                  algorithms.CompareMinHealth,
                  nil)

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
