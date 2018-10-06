local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local map = require(
  GetScriptDirectory() .."/utility/map")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_item_recovery()
  return algorithms.IsBotAlive()
         and not env.BOT_DATA.is_healing

         and constants.BASE_RADIUS
              < functions.GetDistance(
                  env.FOUNTAIN_SPOT,
                  env.BOT_DATA.location)
end

---------------------------------

function M.pre_heal_flask()
  return algorithms.IsItemCastable(env.BOT_DATA, "item_flask")
         and not env.BOT_DATA.is_flask_healing

         and (env.IS_BOT_LOW_HP
              or (420 < (env.BOT_DATA.max_health - env.BOT_DATA.health)
                  and functions.GetRate(
                        env.BOT_DATA.health,
                        env.BOT_DATA.max_health)
                      <= constants.UNIT_HALF_HEALTH_LEVEL))

         and not algorithms.HasModifier(
                   env.BOT_DATA,
                   "modifier_drow_ranger_frost_arrows_slow")
         and constants.BASE_RADIUS
             < functions.GetDistance(
                 env.FOUNTAIN_SPOT,
                 env.BOT_DATA.location)
         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_UNKNOWN_UNIT

         and (env.ENEMY_HERO_DATA == nil
              or (algorithms.GetAttackRange(
                    env.BOT_DATA,
                    env.ENEMY_HERO_DATA,
                    true)
                  + constants.MAX_SAFE_INC_DISTANCE)
                  < env.ENEMY_HERO_DISTANCE)
end

function M.heal_flask()
  env.BOT:Action_UseAbilityOnEntity(
    algorithms.GetItem(env.BOT_DATA, "item_flask"),
    env.BOT)
end

----------------------------------

function M.pre_heal_faerie_fire()
  return env.IS_BOT_LOW_HP
         and algorithms.IsItemCastable(env.BOT_DATA, "item_faerie_fire")
         and not algorithms.IsItemCastable(env.BOT_DATA, "item_tango")
         and not algorithms.IsItemCastable(env.BOT_DATA, "item_flask")
end

function M.heal_faerie_fire()
  env.BOT:Action_UseAbility(
    algorithms.GetItem(env.BOT_DATA, "item_faerie_fire"))
end

---------------------------------

function M.pre_heal_tango()
  local tree = env.BOT_DATA.nearby_trees[1]

  return algorithms.IsItemCastable(env.BOT_DATA, "item_tango")
         and not env.BOT_DATA.is_healing

         and not (env.IS_BOT_LOW_HP
                  and algorithms.IsItemCastable(
                        env.BOT_DATA,
                        "item_flask"))

         and 200 < (env.BOT_DATA.max_health - env.BOT_DATA.health)

         and tree ~= nil

         and (env.ENEMY_TOWER_DATA == nil
              or algorithms.GetAttackRange(
                   env.ENEMY_TOWER_DATA,
                   env.BOT_DATA,
                   true)
                 < functions.GetDistance(
                     GetTreeLocation(tree),
                     env.ENEMY_TOWER_DATA.location))

         and constants.TANGO_USAGE_FROM_HG_DISTANCE
             < functions.GetDistance(
                 map.GetEnemySpot("high_ground"),
                 env.BOT_DATA.location)
end

function M.heal_tango()
  env.BOT:Action_UseAbilityOnTree(
    algorithms.GetItem(env.BOT_DATA, "item_tango"),
    env.BOT_DATA.nearby_trees[1])
end

---------------------------------

function M.pre_tp_base()
  return algorithms.IsItemCastable(env.BOT_DATA, "item_tpscroll")
         and env.BOT_DATA.gold < constants.RESERVED_GOLD
         and env.IS_BOT_LOW_HP
         and constants.MIN_TP_BASE_RADIUS
             < functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)
         and (env.ENEMY_HERO_DATA == nil
              or constants.MIN_TP_ENEMY_HERO_RADIUS
                 < env.ENEMY_HERO_DISTANCE)
         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_faerie_fire")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_flask")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_tango")
end

function M.tp_base()
  local item = algorithms.GetItem(env.BOT_DATA, "item_tpscroll")

  env.BOT:Action_UseAbilityOnLocation(item, env.FOUNTAIN_SPOT)

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

return M
