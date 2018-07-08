local M = {}

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

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
  -- TODO: Should we remove the single objectives here?

  return IsCourierAvailable()
end

function M.pre_buy_and_use_courier()
  return not M.post_buy_and_use_courier()
end

function M.buy_and_use_courier()
  logger.Print("M.buy_and_use_courier()")

  local bot = GetBot()
  local bot_data = common_algorithms.GetBotData()

  bot:ActionImmediate_PurchaseItem('item_courier')

  bot:Action_UseAbility(
    common_algorithms.GetItem(bot_data, 'item_courier'))
end

---------------------------------

function M.post_buy_starting_items()
  local bot_data = common_algorithms.GetBotData()

  return common_algorithms.IsItemPresent(bot_data, 'item_flask')
         and common_algorithms.IsItemPresent(bot_data, 'item_tango')
         and common_algorithms.IsItemPresent(bot_data, 'item_slippers')
         and common_algorithms.IsItemPresent(bot_data, 'item_circlet')
         and common_algorithms.IsItemPresent(bot_data, 'item_branches')
end

function M.pre_buy_starting_items()
  return DotaTime() < 0 and not M.post_buy_starting_items()
end

function M.buy_starting_items()
  logger.Print("M.buy_starting_items()")

  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem('item_flask')
  bot:ActionImmediate_PurchaseItem('item_tango')
  bot:ActionImmediate_PurchaseItem('item_slippers')
  bot:ActionImmediate_PurchaseItem('item_circlet')
  bot:ActionImmediate_PurchaseItem('item_branches')
end

-- Provide an access to local functions for unit tests only

-- The trick with UpdateUnitList is required to keep the UNIT_LIST global
M.test_UpdateUnitList = common_algorithms.test_UpdateUnitList

return M
