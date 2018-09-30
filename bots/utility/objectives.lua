local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local strategies = require(
  GetScriptDirectory() .."/utility/strategies")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local environment = require(
  GetScriptDirectory() .."/utility/environment")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local function FindMoveToExecute(objective)
  return functions.GetElementWith(
           objective.moves,
           nil,
           function(move)
             return objective.module["pre_" .. move.move]()
           end)
end

local function FindObjectiveAndMoveToExecute(strategy)
  local result_objective = nil
  local result_move = nil

  result_objective = functions.GetElementWith(
           strategy.objectives,
           nil,
           function(objective)
             if not objective.module["pre_" .. objective.objective]() then
               return false
             end

             result_move = FindMoveToExecute(objective)

             return result_move ~= nil
           end)

  return result_objective, result_move
end

local function ChooseStrategyObjectiveMove()
  local objective = nil
  local move = nil
  local strategy = functions.GetElementWith(
           objectives.OBJECTIVES,
           nil,
           function(strategy)
             if not strategies["pre_" .. strategy.strategy]() then
               return false end

             objective, move = FindObjectiveAndMoveToExecute(strategy)
             return objective ~= nil and move ~= nil
           end)

  return strategy, objective, move
end

local function GetCurrentAction(move, action_index)
  return move.actions[action_index]
end

local function FindNextAction(move, action_index)
  action_index = action_index + 1

  if #move.actions < action_index then
    action_index = 1
    move = nil
  end

  return move, action_index
end

local function ExecuteAction(objective, move, action_index)
  local current_action = GetCurrentAction(move, action_index)

  if current_action == nil then
    return FindNextAction(move, action_index)
  end

  logger.Print("\tcurrent_action = " ..
    current_action.action .. " ACTION_INDEX = " .. action_index)

  objective.module[current_action.action]()

  return FindNextAction(move, action_index)
end

local function IsActionTimingDelay()
  local action_time = action_timing.GetNextActionTime()

  return action_time ~= 0 and GameTime() < action_time
end

local function IsObjectiveActual(objective)
  if not objective.module["pre_" .. objective.objective]() then
    return false
  end

  return FindMoveToExecute(objective) ~= nil
end

local CURRENT_STRATEGY = nil
local CURRENT_OBJECTIVE = nil
local CURRENT_MOVE = nil
local ACTION_INDEX = 1

function M.Process()
  if IsActionTimingDelay()
     or (algorithms.IsBotAlive() and
         algorithms.GetBotData().is_casting) then
    return end

  environment.UpdateVariables()

  if CURRENT_STRATEGY == nil
     or CURRENT_OBJECTIVE == nil
     or CURRENT_MOVE == nil
     or not IsObjectiveActual(CURRENT_OBJECTIVE) then

    CURRENT_STRATEGY, CURRENT_OBJECTIVE, CURRENT_MOVE =
      ChooseStrategyObjectiveMove()
  end

  if CURRENT_OBJECTIVE ~= nil
     and CURRENT_MOVE ~= nil then

    logger.Print("team = " .. GetTeam() ..
      " current_strategy = " .. CURRENT_STRATEGY.strategy ..
      " current_objective = " .. CURRENT_OBJECTIVE.objective ..
      " current_move = " .. CURRENT_MOVE.move)

    CURRENT_MOVE, ACTION_INDEX = ExecuteAction(
                                   CURRENT_OBJECTIVE,
                                   CURRENT_MOVE,
                                   ACTION_INDEX)
  end
end

-- Provide an access to local functions for unit tests only

return M
