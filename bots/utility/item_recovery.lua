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

local M = {}

local BOT = {}
local BOT_DATA = {}
local ENEMY_HERO_DATA = {}
local SAFE_SPOT = {}
local FOUNTAIN_SPOT = {}

function M.UpdateVariables()
  BOT = GetBot()

  BOT_DATA = common_algorithms.GetBotData()

  ENEMY_HERO_DATA = common_algorithms.GetEnemyHero(
                      BOT_DATA,
                      constants.MAX_UNIT_SEARCH_RADIUS)

  SAFE_SPOT = common_algorithms.GetSafeSpot(BOT_DATA, ENEMY_HERO_DATA)

  FOUNTAIN_SPOT = map.GetAllySpot(BOT_DATA, "fountain")
end

---------------------------------

function M.pre_item_recovery()
  return ((common_algorithms.IsUnitLowHp(BOT_DATA)
           and not BOT_DATA.is_healing))

         and not BOT_DATA.is_casting

         and (M.pre_heal_tango()
              or M.pre_heal_flask()
              or M.pre_heal_faerie_fire()
              or M.pre_tp_base())
end

function M.post_item_recovery()
  return not M.pre_item_recovery()
end

---------------------------------

local function IsItemCastable(item_name)
  return common_algorithms.IsItemPresent(BOT_DATA, item_name)
         and common_algorithms.IsItemInInventory(BOT_DATA, item_name)
         and common_algorithms.GetItem(
               BOT_DATA,
               item_name):IsFullyCastable()
end

function M.pre_heal_faerie_fire()
  return IsItemCastable("item_faerie_fire")
end

function M.post_heal_faerie_fire()
  return not M.pre_heal_faerie_fire()
end

function M.heal_faerie_fire()
  BOT:Action_UseAbility(
    common_algorithms.GetItem(BOT_DATA, "item_faerie_fire"))
end
---------------------------------

function M.pre_heal_flask()
  return IsItemCastable("item_flask")
         and not common_algorithms.IsFocusedByEnemyHero(BOT_DATA)
         and not common_algorithms.IsFocusedByUnknownUnit(BOT_DATA)
         and not common_algorithms.AreUnitsInRadius(
                   BOT_DATA,
                   constants.MAX_HERO_ATTACK_RANGE,
                   common_algorithms.GetEnemyHeroes)
end

function M.post_heal_flask()
  return not M.pre_heal_flask()
end

function M.heal_flask()
  BOT:Action_UseAbilityOnEntity(
    common_algorithms.GetItem(BOT_DATA, "item_flask"),
    BOT)
end

---------------------------------

function M.pre_heal_tango()
  local tower_data = common_algorithms.GetEnemyBuildings(
                           BOT_DATA,
                           constants.MAX_UNIT_SEARCH_RADIUS)[1]

  local tree = BOT_DATA.nearby_trees[1]

  return IsItemCastable("item_tango")
         and tree ~= nil
         and (tower_data == nil
              or constants.MAX_TOWER_ATTACK_RANGE
                 < functions.GetDistance(
                     GetTreeLocation(tree),
                     tower_data.location))

end

function M.post_heal_tango()
  return not M.pre_heal_tango()
end

function M.heal_tango()
  BOT:Action_UseAbilityOnTree(
    common_algorithms.GetItem(BOT_DATA, "item_tango"),
    BOT_DATA.nearby_trees[1])
end

---------------------------------

function M.pre_tp_base()
  return IsItemCastable("item_tpscroll")
         and constants.MIN_TP_BASE_RADIUS
             < functions.GetDistance(FOUNTAIN_SPOT, BOT_DATA.location)
         and (ENEMY_HERO_DATA == nil
              or constants.MIN_TP_ENEMY_HERO_RADIUS
                 < functions.GetUnitDistance(
                     BOT_DATA,
                     ENEMY_HERO_DATA))
         and not map.IsUnitInEnemyTowerAttackRange(BOT_DATA)
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
  local item = common_algorithms.GetItem(BOT_DATA, "item_tpscroll")

  BOT:Action_UseAbilityOnLocation(item, FOUNTAIN_SPOT)

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

function M.pre_move_safe_spot()
  return not common_algorithms.IsUnitMoving(BOT_DATA)
         and not map.IsUnitInSpot(BOT_DATA, SAFE_SPOT)
end

function M.post_move_safe_spot()
  return not M.pre_move_safe_spot()
end

function M.move_safe_spot()
  BOT:Action_MoveToLocation(SAFE_SPOT)
end

---------------------------------

return M
