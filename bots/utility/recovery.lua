local M = {}

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

---------------------------------

local function IsUnitLowHp(unit_data)
  local unit_health = unit_data.health
                      - common_algorithms.GetTotalDamageToUnit(
                          unit_data)

  return unit_health <= constants.UNIT_LOW_HEALTH
         or functions.GetRate(unit_health, unit_data.max_health)
            <= constants.UNIT_LOW_HEALTH_LEVEL
end

function M.pre_recovery()
  local bot_data = common_algorithms.GetBotData()

  return IsUnitLowHp(bot_data)
         and not bot_data.is_casting
         and not bot_data.is_healing
end

function M.post_recovery()
  return not M.pre_recovery()
end

---------------------------------

function M.pre_heal_flask()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_flask')
         and common_algorithms.GetTotalDamageToUnit(bot_data) == 0
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
    common_algorithms.GetItem(bot_data, 'item_flask'),
    bot)
end

---------------------------------

function M.pre_plant_tree()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_tango')
         and bot_data.nearby_trees[1] == nil
         and common_algorithms.IsItemPresent(bot_data, 'item_branches')
end

function M.post_plant_tree()
  return not M.pre_plant_tree()
end

function M.plant_tree()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbilityOnLocation(
    common_algorithms.GetItem(bot_data, 'item_branches'),
    bot_data.location)

  bot_data.nearby_trees = bot:GetNearbyTrees(1000)
end

---------------------------------

function M.pre_heal_tango()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_tango')
         and bot_data.nearby_trees[1] ~= nil
end

function M.post_heal_tango()
  return not M.pre_heal_tango()
end

function M.heal_tango()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbilityOnTree(
    common_algorithms.GetItem(bot_data, 'item_tango'),
    bot_data.nearby_trees[1])
end

---------------------------------

function M.pre_move_shrine()
  return false
end

---------------------------------

function M.pre_tp_base()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_tpscroll')
end

function M.post_tp_base()
  return not M.pre_tp_base()
end

function M.tp_base()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()


  bot:Action_UseAbilityOnLocation(
    common_algorithms.GetItem(bot_data, 'item_tpscroll'),
    GetShopLocation(GetTeam(), SHOP_HOME))
end

---------------------------------

function M.pre_move_base()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()
  local base_location = GetShopLocation(GetTeam(), SHOP_HOME)

  return not (common_algorithms.IsUnitMoving(bot_data)
              and bot:IsFacingLocation(base_location, 30))
end

function M.post_move_base()
  return not M.pre_move_base()
end

function M.move_base()
  local bot = GetBot()
  bot:Action_MoveToLocation(GetShopLocation(GetTeam(), SHOP_HOME))
end

return M
