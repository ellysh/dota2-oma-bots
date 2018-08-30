local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

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

         and (M.pre_heal_tango()
              or M.pre_heal_flask()
              or M.pre_tp_base())

         and constants.BASE_RADIUS
              < functions.GetDistance(
                  env.FOUNTAIN_SPOT,
                  env.BOT_DATA.location)
end

function M.post_item_recovery()
  return not M.pre_item_recovery()
end

---------------------------------

function M.pre_heal_flask()
  return algorithms.IsItemCastable(env.BOT_DATA, "item_flask")
         and (algorithms.IsUnitLowHp(env.BOT_DATA)
              or (420 < (env.BOT_DATA.max_health - env.BOT_DATA.health)
                  and functions.GetRate(
                        env.BOT_DATA.health,
                        env.BOT_DATA.max_health)
                      <= constants.UNIT_HALF_HEALTH_LEVEL))
         and not env.BOT:HasModifier(
                   "modifier_drow_ranger_frost_arrows_slow")
         and constants.BASE_RADIUS
             < functions.GetDistance(
                 env.FOUNTAIN_SPOT,
                 env.BOT_DATA.location)
         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_UNKNOWN_UNIT
         and not algorithms.AreUnitsInRadius(
                   env.BOT_DATA,
                   constants.MAX_HERO_ATTACK_RANGE,
                   algorithms.GetEnemyHeroes)
end

function M.post_heal_flask()
  return env.BOT:HasModifier("modifier_flask_healing")
end

function M.heal_flask()
  env.BOT:Action_UseAbilityOnEntity(
    algorithms.GetItem(env.BOT_DATA, "item_flask"),
    env.BOT)
end

---------------------------------

function M.pre_heal_tango()
  local tower_data = algorithms.GetEnemyBuildings(
                           env.BOT_DATA,
                           constants.MAX_UNIT_SEARCH_RADIUS)[1]

  local tree = env.BOT_DATA.nearby_trees[1]

  return algorithms.IsItemCastable(env.BOT_DATA, "item_tango")
         and tree ~= nil
         and (tower_data == nil
              or constants.MAX_TOWER_ATTACK_RANGE
                 < functions.GetDistance(
                     GetTreeLocation(tree),
                     tower_data.location))
         and (algorithms.IsUnitLowHp(env.BOT_DATA)
              or 200 < (env.BOT_DATA.max_health - env.BOT_DATA.health))
         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_UNKNOWN_UNIT
         and not algorithms.AreUnitsInRadius(
                   env.BOT_DATA,
                   constants.MAX_HERO_ATTACK_RANGE,
                   algorithms.GetEnemyHeroes)

         and constants.TANGO_USAGE_FROM_HG_DISTANCE
             < functions.GetDistance(
                 map.GetEnemySpot("high_ground"),
                 env.BOT_DATA.location)
end

function M.post_heal_tango()
  return env.BOT:HasModifier("modifier_tango_heal")
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
         and algorithms.IsUnitLowHp(env.BOT_DATA)
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

function M.post_tp_base()
  return not M.pre_tp_base()
end

function M.tp_base()
  local item = algorithms.GetItem(env.BOT_DATA, "item_tpscroll")

  env.BOT:Action_UseAbilityOnLocation(item, env.FOUNTAIN_SPOT)

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

return M
