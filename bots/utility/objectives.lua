local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local OBJECTIVE_INDEX = 1
local MOVE_INDEX = 1
local ACTION_INDEX = 1

local function GetCurrentObjective()
  return objectives.OBJECTIVES[OBJECTIVE_INDEX]
end

local function GetCurrentMove()
  return GetCurrentObjective().moves[MOVE_INDEX]
end

local function GetCurrentAction()
  return GetCurrentObjective().moves[MOVE_INDEX].actions[ACTION_INDEX]
end

local function FindNextObjective()
  OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
  if #objectives.OBJECTIVES < OBJECTIVE_INDEX then
    OBJECTIVE_INDEX = 1
  end
end

local function FindNextMove()
  MOVE_INDEX = MOVE_INDEX + 1
  if #GetCurrentObjective().moves < MOVE_INDEX then
    MOVE_INDEX = 1
  end
end

local function FindNextAction()
  ACTION_INDEX = ACTION_INDEX + 1
  if #GetCurrentMove().actions < ACTION_INDEX then
    ACTION_INDEX = 1
  end
end

local function executeMove()
  local current_move = GetCurrentMove()
  local current_objective = GetCurrentObjective()

  local action_time = action_timing.GetNextActionTime()

  if action_time ~= 0 and GameTime() < action_time then
    return end

  if current_move == nil or
     not current_objective.module["pre_" .. current_move.move]() then
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

  logger.Print("\tcurrent_move = " ..
    current_move.move .. " MOVE_INDEX = " .. MOVE_INDEX)

  local current_action = GetCurrentAction()

  if current_action == nil then
    FindNextAction()
    return
  end

  logger.Print("\tcurrent_action = " ..
    current_action.action .. " ACTION_INDEX = " .. ACTION_INDEX)

  current_objective.module[current_action.action]()

  FindNextAction()
end

local function IsBotAlive()
  return common_algorithms.GetBotData() ~= nil
end

function M.Process()
  if not IsBotAlive() then
    return end

  local current_objective = GetCurrentObjective()

  current_objective.UpdateVariables()

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
