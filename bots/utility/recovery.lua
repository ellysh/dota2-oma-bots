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

local buy_items = require(
  GetScriptDirectory() .."/utility/buy_items")

local upgrade_skills = require(
  GetScriptDirectory() .."/utility/upgrade_skills")

local M = {}

local BOT = {}
local BOT_DATA = {}

function M.UpdateVariables()
  BOT = GetBot()
  BOT_DATA = common_algorithms.GetBotData()
end

---------------------------------

function M.pre_restore_hp_on_base()
  return BOT:HasModifier("modifier_fountain_aura_buff")
         and (BOT_DATA.health < BOT_DATA.max_health
              or BOT_DATA.mana < BOT_DATA.max_mana)
end

function M.post_restore_hp_on_base()
  return not M.pre_restore_hp_on_base()
end

function M.restore_hp_on_base()
  BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_recovery()
  return ((common_algorithms.IsUnitLowHp(BOT_DATA)
           and not BOT_DATA.is_healing)

          or M.pre_restore_hp_on_base())

         and not BOT_DATA.is_casting
         and not buy_items.pre_buy_items()
         and not upgrade_skills.pre_upgrade_skills()
end

function M.post_recovery()
  return not M.pre_recovery()
end

---------------------------------

local function IsItemCastable(item_name)
  return not BOT_DATA.is_silenced
         and common_algorithms.IsItemPresent(BOT_DATA, item_name)
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

function M.pre_move_shrine()
  return false
end

---------------------------------

function M.pre_tp_base()
  return IsItemCastable("item_tpscroll")
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

  BOT:Action_UseAbilityOnLocation(
    item,
    map.GetAllySpot(BOT_DATA, "fountain"))

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

function M.pre_move_base()
  local base_location = map.GetAllySpot(BOT_DATA, "fountain")

  return not (common_algorithms.IsUnitMoving(BOT_DATA)
              and BOT:IsFacingLocation(base_location, 30))
end

function M.post_move_base()
  return not M.pre_move_base()
end

function M.move_base()
  BOT:Action_MoveToLocation(map.GetAllySpot(BOT_DATA, "fountain"))
end

---------------------------------

return M
