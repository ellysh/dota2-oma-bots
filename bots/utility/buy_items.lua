local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local M = {}

---------------------------------

function M.pre_buy_items()
  return M.pre_buy_flask()
         or M.pre_buy_faerie_fire()
end

function M.post_buy_items()
  return not M.pre_buy_items()
end

---------------------------------

function M.pre_buy_flask()
  local bot_data = common_algorithms.GetBotData()
  local courier_data = common_algorithms.GetCourierData()

  return not common_algorithms.IsItemPresent(bot_data, 'item_flask')
         and not common_algorithms.IsItemPresent(courier_data, 'item_flask')
end

function M.post_buy_flask()
  return not M.pre_buy_flask()
end

function M.buy_flask()
  local bot = GetBot()
  local courier = GetCourier(0)

  bot:ActionImmediate_PurchaseItem('item_flask')

  bot:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

---------------------------------

function M.pre_buy_faerie_fire()
  return false
end

-- Provide an access to local functions for unit tests only

return M
