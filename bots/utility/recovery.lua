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

function M.pre_restore_hp_on_base()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  return bot:HasModifier("modifier_fountain_aura_buff")
         and (bot_data.health < bot_data.max_health
              or bot_data.mana < bot_data.max_mana)
end

function M.post_restore_hp_on_base()
  return not M.pre_restore_hp_on_base()
end

function M.restore_hp_on_base()
  local bot = GetBot()
  bot:Action_ClearActions(true)
end

---------------------------------

function M.pre_recovery()
  local bot_data = common_algorithms.GetBotData()

  return ((common_algorithms.IsUnitLowHp(bot_data)
           and not bot_data.is_healing)

          or M.pre_restore_hp_on_base())

         and not bot_data.is_casting
end

function M.post_recovery()
  return not M.pre_recovery()
end

---------------------------------

function M.pre_heal_faerie_fire()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, "item_faerie_fire")
end

function M.post_heal_faerie_fire()
  return not M.pre_heal_faerie_fire()
end

function M.heal_faerie_fire()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbility(
    common_algorithms.GetItem(bot_data, "item_faerie_fire"))
end
---------------------------------

function M.pre_heal_flask()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, "item_flask")
         and common_algorithms.GetTotalDamageToUnit(bot_data, nil) == 0
         and not common_algorithms.AreUnitsInRadius(
                   bot_data,
                   constants.MAX_HERO_ATTACK_RANGE,
                   common_algorithms.GetEnemyHeroes)
end

function M.post_heal_flask()
  return not M.pre_heal_flask()
end

function M.heal_flask()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbilityOnEntity(
    common_algorithms.GetItem(bot_data, "item_flask"),
    bot)
end

---------------------------------

function M.pre_heal_tango()
  local bot_data = common_algorithms.GetBotData()

  local tower_data = common_algorithms.GetEnemyBuildings(
                           bot_data,
                           constants.MAX_UNIT_SEARCH_RADIUS)[1]

  local tree = bot_data.nearby_trees[1]

  return common_algorithms.IsItemPresent(bot_data, "item_tango")
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
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbilityOnTree(
    common_algorithms.GetItem(bot_data, "item_tango"),
    bot_data.nearby_trees[1])
end

---------------------------------

function M.pre_move_shrine()
  return false
end

---------------------------------

function M.pre_tp_base()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, "item_tpscroll")
         and not common_algorithms.IsItemPresent(
                   bot_data,
                   "item_faerie_fire")
         and not common_algorithms.IsItemPresent(
                   bot_data,
                   "item_flask")
         and not common_algorithms.IsItemPresent(
                   bot_data,
                   "item_tango")
         and common_algorithms.GetItem(
              bot_data,
              "item_tpscroll"):IsFullyCastable()
end

function M.post_tp_base()
  return not M.pre_tp_base()
end

function M.tp_base()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()
  local item = common_algorithms.GetItem(bot_data, "item_tpscroll")

  bot:Action_UseAbilityOnLocation(
    item,
    map.GetAllySpot(bot_data, "fountain"))

  action_timing.SetNextActionDelay(item:GetChannelTime())
end

---------------------------------

function M.pre_move_base()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()
  local base_location = map.GetAllySpot(bot_data, "fountain")

  return not (common_algorithms.IsUnitMoving(bot_data)
              and bot:IsFacingLocation(base_location, 30))
end

function M.post_move_base()
  return not M.pre_move_base()
end

function M.move_base()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_MoveToLocation(map.GetAllySpot(bot_data, "fountain"))
end

---------------------------------

return M
