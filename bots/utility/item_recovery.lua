local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

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
  return ((common_algorithms.IsUnitLowHp(env.BOT_DATA)
           and not env.BOT_DATA.is_healing))

         and constants.BASE_RADIUS
             < functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)

         and (M.pre_heal_tango()
              or M.pre_heal_flask()
              or M.pre_heal_faerie_fire()
              or M.pre_tp_base())
end

function M.post_item_recovery()
  return not M.pre_item_recovery()
end

---------------------------------

function M.pre_heal_faerie_fire()
  return common_algorithms.IsItemCastable(env.BOT_DATA, "item_faerie_fire")
end

function M.post_heal_faerie_fire()
  return not M.pre_heal_faerie_fire()
end

function M.heal_faerie_fire()
  env.BOT:Action_UseAbility(
    common_algorithms.GetItem(env.BOT_DATA, "item_faerie_fire"))
end
---------------------------------

function M.pre_heal_flask()
  return common_algorithms.IsItemCastable(env.BOT_DATA, "item_flask")
         and not common_algorithms.IsFocusedByEnemyHero(env.BOT_DATA)
         and not common_algorithms.IsFocusedByUnknownUnit(env.BOT_DATA)
         and not common_algorithms.AreUnitsInRadius(
                   env.BOT_DATA,
                   constants.MAX_HERO_ATTACK_RANGE,
                   common_algorithms.GetEnemyHeroes)
end

function M.post_heal_flask()
  return env.BOT:HasModifier("modifier_flask_healing")
end

function M.heal_flask()
  env.BOT:Action_UseAbilityOnEntity(
    common_algorithms.GetItem(env.BOT_DATA, "item_flask"),
    env.BOT)

  action_timing.SetNextActionDelay(4)
end

---------------------------------

function M.pre_heal_tango()
  local tower_data = common_algorithms.GetEnemyBuildings(
                           env.BOT_DATA,
                           constants.MAX_UNIT_SEARCH_RADIUS)[1]

  local tree = env.BOT_DATA.nearby_trees[1]

  return common_algorithms.IsItemCastable(env.BOT_DATA, "item_tango")
         and tree ~= nil
         and (tower_data == nil
              or constants.MAX_TOWER_ATTACK_RANGE
                 < functions.GetDistance(
                     GetTreeLocation(tree),
                     tower_data.location))

end

function M.post_heal_tango()
  return env.BOT:HasModifier("modifier_tango_heal")
end

function M.heal_tango()
  env.BOT:Action_UseAbilityOnTree(
    common_algorithms.GetItem(env.BOT_DATA, "item_tango"),
    env.BOT_DATA.nearby_trees[1])
end

---------------------------------

function M.pre_tp_base()
  return common_algorithms.IsItemCastable(env.BOT_DATA, "item_tpscroll")
         and constants.MIN_TP_BASE_RADIUS
             < functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)
         and (env.ENEMY_HERO_DATA == nil
              or constants.MIN_TP_ENEMY_HERO_RADIUS
                 < functions.GetUnitDistance(
                     env.BOT_DATA,
                     env.ENEMY_HERO_DATA))
         and not map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_faerie_fire")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_flask")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_tango")
end

function M.post_tp_base()
  return not M.pre_tp_base()
end

function M.tp_base()
  local item = common_algorithms.GetItem(env.BOT_DATA, "item_tpscroll")

  env.BOT:Action_UseAbilityOnLocation(item, env.FOUNTAIN_SPOT)

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

function M.pre_move_safe_spot()
  return not common_algorithms.IsUnitMoving(env.BOT_DATA)
         and not map.IsUnitInSpot(env.BOT_DATA, env.SAFE_SPOT)
end

function M.post_move_safe_spot()
  return not M.pre_move_safe_spot()
end

function M.move_safe_spot()
  env.BOT:Action_MoveToLocation(env.SAFE_SPOT)
end

---------------------------------

return M
