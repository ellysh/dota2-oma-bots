local M = {}

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

---------------------------------

function M.pre_prepare_for_match()
  return DotaTime() < 0
end

function M.post_prepare_for_match()
  return M.post_buy_and_use_courier() and M.post_buy_starting_items()
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

  bot:ActionImmediate_PurchaseItem('item_courier')

  bot:Action_UseAbility(functions.GetItem(bot, 'item_courier', nil))
end

---------------------------------

function M.post_buy_starting_items()
  local bot = GetBot()

  return functions.IsItemPresent(bot, 'item_flask')
         and functions.IsItemPresent(bot, 'item_tango')
         and functions.IsItemPresent(bot, 'item_slippers')
         and functions.IsItemPresent(bot, 'item_circlet')
         and functions.IsItemPresent(bot, 'item_branches')
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

return M