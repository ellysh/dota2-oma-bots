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

function M.pre_prepare_for_match()
  return DotaTime() < 0
         and (M.pre_buy_starting_items()
              or M.pre_move_start_position())
end

function M.post_prepare_for_match()
  return not M.pre_prepare_for_match()
end

---------------------------------

function M.post_buy_starting_items()
  return algorithms.IsItemPresent(env.BOT_DATA, "item_tango")
         and algorithms.IsItemPresent(env.BOT_DATA, "item_wraith_band")
end

function M.pre_buy_starting_items()
  return DotaTime() < 0 and not M.post_buy_starting_items()
end

function M.buy_starting_items()
  algorithms.BuyItem("item_tango")
  algorithms.BuyItem("item_recipe_wraith_band")
  algorithms.BuyItem("item_slippers")
  algorithms.BuyItem("item_circlet")

  action_timing.SetNextActionDelay(0.5)
end

---------------------------------

function M.pre_move_start_position()
  return not map.IsUnitInSpot(
               env.BOT_DATA,
               map.GetAllySpot(env.BOT_DATA, "start_body_block"))
end

function M.post_move_start_position()
  return not M.pre_move_start_position()
end

function M.move_start_position()
  env.BOT:Action_MoveToLocation(
    map.GetAllySpot(env.BOT_DATA, "start_body_block"))

  action_timing.SetNextActionDelay(5)
end

-- Provide an access to local functions for unit tests only

return M
