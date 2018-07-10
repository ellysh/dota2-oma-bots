local M = {}

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local OBJECTIVES = {
  [1] = {
    objective = "prepare_for_match",
    module = require(GetScriptDirectory() .."/utility/prepare_for_match"),
    moves = {
      {move = "buy_and_use_courier"},
      {move = "buy_starting_items"},
    },
  },
  [2] = {
    objective = "laning",
    module = require(GetScriptDirectory() .."/utility/laning"),
    moves = {
      {move = "lasthit_enemy_creep"},
      {move = "deny_ally_creep"},
      {move = "harras_enemy_hero"},
      {move = "evasion"},
      {move = "move_mid_front_lane"},
      {move = "positioning"},
      {move = "turn"},
      {move = "stop"},
    },
  },
  [3] = {
    objective = "recovery",
    module = require(GetScriptDirectory() .."/utility/recovery"),
    moves = {
      {move = "move_base"},
      {move = "plant_tree"},
      {move = "heal_tango"},
      {move = "heal_flask"},
      {move = "move_shrine"},
      {move = "tp_base"},
    },
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
  local current_objective = GetCurrentObjective()

  local move_time = current_objective.module.GetNextMoveTime()

  if move_time ~= 0 and GameTime() < move_time then
    current_objective.module.SetNextMoveTime(0)
    return
  end

  if not current_objective.module["pre_" .. current_move.move]() then
    FindNextMove()
    return
  end

  if current_objective.module["post_" .. current_move.move]() then
    MOVE_INDEX = 1
    return
  end

  logger.Print("team = " .. GetTeam() .. " current_objective = " ..
    current_objective.objective .. " OBJECTIVE_INDEX = " ..
    OBJECTIVE_INDEX)

  logger.Print("team = " .. GetTeam() .. " current_move = " ..
    current_move.move .. " MOVE_INDEX = " .. MOVE_INDEX)

  current_objective.module[current_move.move]()
end

local function IsBotAlive()
  return common_algorithms.GetBotData() ~= nil
end

function M.Process()
  if not IsBotAlive() then
    return end

  local current_objective = GetCurrentObjective()

  if not current_objective.done
     and current_objective.module["pre_" .. current_objective.objective]() then

    executeMove(current_objective)
  else
    -- We should find another objective here
    FindNextObjective()
    return
  end

  if current_objective.module["post_" .. current_objective.objective]() then
    current_objective.done = true
    FindNextObjective()
  end
end

-- Provide an access to local functions for unit tests only

return M
