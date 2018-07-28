local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local CURRENT_OBJECTIVE = nil
local CURRENT_MOVE = nil
local ACTION_INDEX = 1

local function IsBotAlive()
  return common_algorithms.GetBotData() ~= nil
end

local function UpdateVariablesOfAllModules()
  for _, objective in pairs(objectives.OBJECTIVES) do
    objective.module.UpdateVariables()
  end
end

local function FindObjectiveToExecute()
  return functions.GetElementWith(
           objectives.OBJECTIVES,
           nil,
           function(objective)
             return objective.module[
                      "pre_" .. objective.objective]()
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

local function ExecuteMove()
  if CURRENT_MOVE == nil
     or CURRENT_MOVE.is_interruptible
     or (not CURRENT_MOVE.is_interruptible
         and CURRENT_OBJECTIVE.module["post_" .. CURRENT_MOVE.move]()) then
    CURRENT_MOVE = FindMoveToExecute()
  end

  ExecuteAction()
end

local function GetCurrentAction()
  return CURRENT_MOVE.actions[ACTION_INDEX]
end

local function FindNextAction()
  ACTION_INDEX = ACTION_INDEX + 1
  if #GetCurrentMove().actions < ACTION_INDEX then
    ACTION_INDEX = 1
  end
end

local function ExecuteAction()
  local current_action = GetCurrentAction()

  logger.Print("team = " .. GetTeam() .. " current_objective = " ..
    CURRENT_OBJECTIVE.objective)

  logger.Print("\tcurrent_move = " .. CURRENT_MOVE.move)

  if current_action == nil then
    FindNextAction()
    return
  end

  logger.Print("\tcurrent_action = " ..
    current_action.action .. " ACTION_INDEX = " .. ACTION_INDEX)

  current_objective.module[current_action.action]()

  FindNextAction()
end

local function IsActionTimingDelay()
  local action_time = action_timing.GetNextActionTime()

  return action_time ~= 0 and GameTime() < action_time
end

function M.Process()
  if not IsBotAlive() or IsActionTimingDelay() then
    return end

  UpdateVariablesOfAllModules()

  if CURRENT_OBJECTIVE == nil
     or CURRENT_OBJECTIVE.is_interruptible
     or (not CURRENT_OBJECTIVE.is_interruptible
         and CURRENT_OBJECTIVE.module["post_" .. CURRENT_OBJECTIVE.objective]()) then
    CURRENT_OBJECTIVE = FindObjectiveToExecute()
  end

  ExecuteMove()
end

-- Provide an access to local functions for unit tests only

return M
