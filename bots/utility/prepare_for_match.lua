local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local M = {}

---------------------------------

local function IsGameStart()
  return 0 < DotaTime()
end

function M.pre_prepare_for_match()
  return not IsGameStart()
         and algorithms.IsBotAlive()
end

function M.pre_buy_starting_items()
  return not IsGameStart()
         and not algorithms.IsItemPresent(
                   env.BOT_DATA, "item_faerie_fire")
end

function M.buy_starting_items()
  algorithms.BuyItem("item_slippers")
  algorithms.BuyItem("item_circlet")
  algorithms.BuyItem("item_recipe_wraith_band")
  algorithms.BuyItem("item_faerie_fire")

  action_timing.SetNextActionDelay(0.5)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
