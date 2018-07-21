local M = {}

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

---------------------------------

function M.pre_prepare_for_match()
  return DotaTime() < 0
end

function M.post_prepare_for_match()
  return (M.post_buy_and_use_courier()
          and M.post_buy_starting_items())

         or not M.pre_prepare_for_match()
end

---------------------------------

function M.post_buy_and_use_courier()
  return IsCourierAvailable()
end

function M.pre_buy_and_use_courier()
  return not M.post_buy_and_use_courier()
end

function M.buy_courier()
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem('item_courier')

  action_timing.SetNextActionDelay(0.3)
end

function M.use_courier()
  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:Action_UseAbility(
    common_algorithms.GetItem(bot_data, 'item_courier'))

  action_timing.SetNextActionDelay(0.5)
end

---------------------------------

function M.post_buy_starting_items()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_faerie_fire')
         and common_algorithms.IsItemPresent(bot_data, 'item_wraith_band')
         and common_algorithms.IsItemPresent(bot_data, 'item_branches')
end

function M.pre_buy_starting_items()
  return DotaTime() < 0 and not M.post_buy_starting_items()
end

function M.buy_starting_items()
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem('item_faerie_fire')
  bot:ActionImmediate_PurchaseItem('item_recipe_wraith_band')
  bot:ActionImmediate_PurchaseItem('item_slippers')
  bot:ActionImmediate_PurchaseItem('item_circlet')
  bot:ActionImmediate_PurchaseItem('item_branches')

  action_timing.SetNextActionDelay(0.5)
end

-- Provide an access to local functions for unit tests only

-- The trick with UpdateUnitList is required to keep the UNIT_LIST global
M.test_UpdateUnitList = common_algorithms.test_UpdateUnitList

return M
