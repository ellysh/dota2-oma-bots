local M = {}

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local OBJECTIVES = {
  [1] = {
    objective = "prepare_for_match",
    module = require(GetScriptDirectory() .."/utility/prepare_for_match"),
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
    module = require(GetScriptDirectory() .."/utility/laning"),
    moves = {
      {move = "tp_out", desire = 100},
      {move = "evasion", desire = 90},
      {move = "move_mid_front_lane", desire = 80},
      {move = "lasthit_enemy_creep", desire = 75},
      {move = "deny_ally_creep", desire = 60},
      {move = "harras_enemy_hero", desire = 50},
      {move = "positioning", desire = 45},
      {move = "attack_enemy_building", desire = 40},
      {move = "turn", desire = 10},
      {move = "stop", desire = 1},
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

  logger.Print("current_move = " .. current_move.move ..
    " MOVE_INDEX = " .. MOVE_INDEX)

  if not M["pre_" .. current_move.move]() then
    FindNextMove()
    return
  end

  if M["post_" .. current_move.move]() then
    MOVE_INDEX = 1
    return
  end

  M[current_move.move]()
end

function M.Process()
  local current_objective = GetCurrentObjective()

  logger.Print("current_objective = " .. current_objective.objective ..
    " OBJECTIVE_INDEX = " .. OBJECTIVE_INDEX)

  if not current_objective.done
     and M["pre_" .. current_objective.objective]() then

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
