local M = {}

local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local moves = require(
  GetScriptDirectory() .."/database/moves")

local code_snippets = require(
  GetScriptDirectory() .."/database/code_snippets")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local OBJECTIVES = {
  "buy_and_use_courier",
  "buy_starting_items",
  "move_mid_front_lane",
  "laning"
}

local OBJECTIVE_INDEX = 1

function M.post_buy_and_use_courier()
  -- TODO: Should we remove the single objectives here?

  return IsCourierAvailable()
end

function M.pre_buy_and_use_courier()
  return DotaTime() < 0 and not M.post_buy_and_use_courier()
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

---------------------------------

function M.post_move_mid_front_lane()
  local target_location = GetLaneFrontLocation(
    GetTeam(),
    LANE_MID,
    0)

  local target_distance = GetUnitToLocationDistance(
    GetBot(),
    target_location)

  print("M.post_move_mid_front_lane() - distance = " .. target_distance)
  return target_distance <= constants.MAP_LOCATION_RADIUS
end

function M.pre_move_mid_front_lane()
  print("M.pre_move_mid_front_lane() - result = " .. tostring(not M.post_move_mid_front_lane()))
  return not M.post_move_mid_front_lane()
end

function M.move_mid_front_lane()
  logger.Print("M.move_mid_front_lane()")

  local target_location = GetLaneFrontLocation(
    GetTeam(),
    LANE_MID,
    0)

  GetBot():Action_MoveToLocation(target_location)
end

---------------------------------

function M.post_laning()
  return false
end

function M.pre_laning()
  -- This is a objectives Dependency example

  return M.post_move_mid_front_lane()
end

function M.laning()
  print("M.laning()")

  local bot = GetBot()

  local enemy_creeps = bot:GetNearbyCreeps(
    1600,
    true)

  if enemy_creeps == nil or #enemy_creeps == 0 then
    print("M.laning() - no enemy")
    return end

  bot:SetTarget(enemy_creeps[1])

  bot:Action_AttackUnit(enemy_creeps[1], false)
end

---------------------------------

function M.Process()
  local current_objective = OBJECTIVES[OBJECTIVE_INDEX]

  if M["pre_" .. current_objective]() then
    M[current_objective]()
  end

  if M["post_" .. current_objective]() then
    OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
    if #OBJECTIVES < OBJECTIVE_INDEX then
      OBJECTIVE_INDEX = 1
    end

    logger.Print("OBJECTIVE_INDEX = " .. OBJECTIVE_INDEX)
  end
end

-- Provide an access to local functions for unit tests only

return M
