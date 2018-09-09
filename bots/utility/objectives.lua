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

local CURRENT_STRATEGY = nil
local CURRENT_OBJECTIVE = nil
local CURRENT_MOVE = nil
local ACTION_INDEX = 1

local function ChooseStrategy()
  return functions.GetElementWith(
           objectives.OBJECTIVES,
           nil,
           function(strategy)
             return strategies[
                      "pre_" .. strategy.strategy]()
           end)
end

local function FindMoveToExecute()
  return functions.GetElementWith(
           CURRENT_OBJECTIVE.moves,
           nil,
           function(move)
             return CURRENT_OBJECTIVE.module["pre_" .. move.move]()
           end)
end

local function FindObjectiveAndMoveToExecute()
  return functions.GetElementWith(
           CURRENT_STRATEGY.objectives,
           nil,
           function(objective)
             if not objective.module["pre_" .. objective.objective]() then
               return false
             end

             CURRENT_OBJECTIVE = objective
             CURRENT_MOVE = FindMoveToExecute()

             return CURRENT_MOVE ~= nil
           end)
end

local function GetCurrentAction()
  return CURRENT_MOVE.actions[ACTION_INDEX]
end

local function FindNextAction()
  ACTION_INDEX = ACTION_INDEX + 1
  if #CURRENT_MOVE.actions < ACTION_INDEX then
    ACTION_INDEX = 1
    CURRENT_MOVE = nil
  end
end

local function ExecuteAction()
  local current_action = GetCurrentAction()

  logger.Print("team = " .. GetTeam() ..
   " current_strategy = " .. CURRENT_STRATEGY.strategy ..
   " current_objective = " .. CURRENT_OBJECTIVE.objective)

  logger.Print("\tcurrent_move = " .. CURRENT_MOVE.move)

  if current_action == nil then
    FindNextAction()
    return
  end

  logger.Print("\tcurrent_action = " ..
    current_action.action .. " ACTION_INDEX = " .. ACTION_INDEX)

  CURRENT_OBJECTIVE.module[current_action.action]()

  FindNextAction()
end

local function IsActionTimingDelay()
  local action_time = action_timing.GetNextActionTime()

  return action_time ~= 0 and GameTime() < action_time
end

function M.Process()
  if IsActionTimingDelay()
     or (algorithms.IsBotAlive() and
         algorithms.GetBotData().is_casting) then
    return end

  environment.UpdateVariables()

  if CURRENT_STRATEGY == nil
     or CURRENT_OBJECTIVE == nil

     or (CURRENT_OBJECTIVE.is_interruptible
         and (CURRENT_MOVE == nil
              or CURRENT_MOVE.is_interruptible)) then

    CURRENT_STRATEGY = ChooseStrategy()
    FindObjectiveAndMoveToExecute()
  end

  if CURRENT_OBJECTIVE ~= nil
     and CURRENT_MOVE ~= nil then

    ExecuteAction()
  end
end

-- Provide an access to local functions for unit tests only

return M
