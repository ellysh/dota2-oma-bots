local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local M = {}

---------------------------------

function M.pre_buy_items()
  return M.pre_buy_flask()
         or M.pre_buy_faerie_fire()
         or M.pre_deliver_items()
end

function M.post_buy_items()
  return not M.pre_buy_items()
end

---------------------------------

local function IsEnoughGoldToBuy(item_name)
  local bot_data = common_algorithms.GetBotData()

  return GetItemCost(item_name) <= bot_data.gold
end

function M.pre_buy_flask()
  local bot_data = common_algorithms.GetBotData()
  local courier_data = common_algorithms.GetCourierData()

  return not common_algorithms.IsItemPresent(bot_data, "item_flask")
         and not common_algorithms.IsItemPresent(courier_data, "item_flask")
         and IsEnoughGoldToBuy("item_flask")
end

function M.post_buy_flask()
  return not M.pre_buy_flask()
end

function M.buy_flask()
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem("item_flask")
end

---------------------------------

-- TODO: This code duplicates the buy_flask move. Generalize it.

function M.pre_buy_faerie_fire()
  local bot_data = common_algorithms.GetBotData()
  local courier_data = common_algorithms.GetCourierData()

  return not common_algorithms.IsItemPresent(bot_data, "item_faerie_fire")
         and not common_algorithms.IsItemPresent(courier_data, "item_faerie_fire")
         and IsEnoughGoldToBuy("item_faerie_fire")
end

function M.post_buy_faerie_fire()
  return not M.pre_buy_faerie_fire()
end

function M.buy_faerie_fire()
  local bot = GetBot()

  bot:ActionImmediate_PurchaseItem("item_faerie_fire")
end

---------------------------------

function M.pre_deliver_items()
  local bot_data = common_algorithms.GetBotData()
  local courier_data = common_algorithms.GetCourierData()

  return 0 < bot_data.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot(bot_data, "fountain"))
end

function M.post_deliver_items()
  return not M.pre_deliver_items()
end

function M.deliver_items()
  local bot = GetBot()
  local courier = GetCourier(0)

  bot:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

-- Provide an access to local functions for unit tests only

return M
