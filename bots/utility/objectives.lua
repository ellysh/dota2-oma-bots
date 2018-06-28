local M = {}

local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local moves = require(
  GetScriptDirectory() .."/database/moves")

local code_snippets = require(
  GetScriptDirectory() .."/database/code_snippets")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local OBJECTIVES = {
  [1] = {
    objective = "prepare_for_match",
    moves = {
      {move = "buy_and_use_courier", desire = 80},
      {move = "buy_starting_items", desire = 70},
    },
    dependencies = {},
    desire = 100,
    single = true,
    done = false,
  },
  [2] = {
    objective = "laning",
    moves = {
      {move = "tp_out", desire = 100},
      {move = "evasion", desire = 90},
      {move = "move_mid_front_lane", desire = 80},
      {move = "lasthit_enemy_creep", desire = 70},
      {move = "deny_ally_creep", desire = 60},
      {move = "harras_enemy_herp", desire = 50},
    },
    dependencies = {
      {objective = "prepare_for_match"},
    },
    desire = 90,
    single = false,
    done = false,
  },
}

local OBJECTIVE_INDEX = 1
local MOVE_INDEX = 1

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

  return target_distance <= constants.MAP_LOCATION_RADIUS
end

function M.pre_move_mid_front_lane()
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
  logger.Print("M.laning()")

  local bot = GetBot()

  local enemy_creeps = common_algorithms.GetEnemyCreeps(bot, 1600)

  if enemy_creeps ~= nil and 0 < #enemy_creeps then
    bot:SetTarget(enemy_creeps[1])

    bot:Action_AttackUnit(enemy_creeps[1], false)
    return
  end

  local enemy_heroes = common_algorithms.GetEnemyHeroes(bot, 1600)

  if enemy_heroes ~= nil and 0 < #enemy_heroes then
    bot:SetTarget(enemy_heroes[1])

    bot:Action_AttackUnit(enemy_heroes[1], false)
    return
  end

  local enemy_buildings = common_algorithms.GetEnemyBuildings(bot, 1600)

  if enemy_buildings ~= nil and 0 < #enemy_buildings then
    bot:SetTarget(enemy_buildings[1])

    bot:Action_AttackUnit(enemy_buildings[1], false)
    return
  end

end

---------------------------------

local function GetCurrentObjective()
  return OBJECTIVES[OBJECTIVE_INDEX]
end

local function GetCurrentMove()
  return GetCurrentObjective().moves[MOVE_INDEX]
end

local function FindNextObjective()
  -- TODO: Consider desire values here

  OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
  if #OBJECTIVES < OBJECTIVE_INDEX then
    OBJECTIVE_INDEX = 1
  end
end

local function FindNextMove()
  -- TODO: Consider desire values here

  MOVE_INDEX = MOVE_INDEX + 1
  if #GetCurrentObjective().moves < MOVE_INDEX then
    MOVE_INDEX = 1
  end
end

local function executeMove()
  local current_move = GetCurrentMove()

  if M["pre_" .. current_move.move]() then
    M[current_move.move]()
  else
    FindNextMove()
  end

  if M["post_" .. current_move.move]() then
    FindNextMove()
  end
end

function M.Process()
  local current_objective = GetCurrentObjective()

  logger.Print("current_objective = " .. current_objective.objective ..
    " OBJECTIVE_INDEX = " .. OBJECTIVE_INDEX)

  print("pre_" .. current_objective.objective)

  if not current_objective.done
     and M["pre_" .. current_objective.objective]() then

     --M[current_objective.objective]()
     executeMove(current_objective)
  else
    -- We should find another objective here
    FindNextObjective()
    return
  end

  if M["post_" .. current_objective.objective]() then
    current_objective.done = true
    FindNextObjective()
  end
end

-- Provide an access to local functions for unit tests only

return M
