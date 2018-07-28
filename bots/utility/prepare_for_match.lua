local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local BOT_DATA = {}

function M.UpdateVariables()
  BOT_DATA = common_algorithms.GetBotData()
end

---------------------------------

function M.pre_prepare_for_match()
  return DotaTime() < 0
         and (M.pre_buy_and_use_courier()
              or M.pre_buy_starting_items())
end

function M.post_prepare_for_match()
  return not M.pre_prepare_for_match()
end

---------------------------------

function M.post_buy_and_use_courier()
  return IsCourierAvailable()
end

function M.pre_buy_and_use_courier()
  return not M.post_buy_and_use_courier()
end

function M.buy_courier()
  common_algorithms.BuyItem("item_courier")

  action_timing.SetNextActionDelay(0.3)
end

function M.use_courier()
  local bot = GetBot()

  bot:Action_UseAbility(
    common_algorithms.GetItem(BOT_DATA, "item_courier"))

  action_timing.SetNextActionDelay(0.5)
end

---------------------------------

function M.post_buy_starting_items()
  return common_algorithms.IsItemPresent(BOT_DATA, "item_faerie_fire")
         and common_algorithms.IsItemPresent(BOT_DATA, "item_wraith_band")
         and common_algorithms.IsItemPresent(BOT_DATA, "item_branches")
end

function M.pre_buy_starting_items()
  return DotaTime() < 0 and not M.post_buy_starting_items()
end

function M.buy_starting_items()
  common_algorithms.BuyItem("item_faerie_fire")
  common_algorithms.BuyItem("item_recipe_wraith_band")
  common_algorithms.BuyItem("item_slippers")
  common_algorithms.BuyItem("item_circlet")
  common_algorithms.BuyItem("item_branches")

  action_timing.SetNextActionDelay(0.5)
end

-- Provide an access to local functions for unit tests only

return M
