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
      {move = "buy_and_use_courier",
       actions = {
         {action = "buy_courier"},
         {action = "use_courier"},
       },
      },
      --[[
      {move = "buy_starting_items",
       actions = {
         {action = "buy_flask"},
         {action = "buy_tango"},
         {action = "buy_slippers"},
         {action = "buy_circlet"},
         {action = "buy_branches"},
       }
      },
      --]]
    },
  },
  --[[
  [2] = {
    objective = "laning",
    module = require(GetScriptDirectory() .."/utility/laning"),
    moves = {
      {move = "lasthit_enemy_creep", actions = {}},
      {move = "deny_ally_creep", actions = {}},
      {move = "harras_enemy_hero", actions = {}},
      {move = "evasion", actions = {}},
      {move = "move_mid_front_lane", actions = {}},
      {move = "positioning", actions = {}},
      {move = "turn", actions = {}},
      {move = "stop", actions = {}},
    },
  },
  [3] = {
    objective = "recovery",
    module = require(GetScriptDirectory() .."/utility/recovery"),
    moves = {
      {move = "move_base", actions = {}},
      {move = "heal_tango", actions = {}},
      {move = "heal_flask", actions = {}},
      {move = "move_shrine", actions = {}},
      {move = "tp_base", actions = {}},
    },
  },
  --]]
}

local OBJECTIVE_INDEX = 1
local MOVE_INDEX = 1
local ACTION_INDEX = 1

local function GetCurrentObjective()
  return OBJECTIVES[OBJECTIVE_INDEX]
end

local function GetCurrentMove()
  return GetCurrentObjective().moves[MOVE_INDEX]
end

local function GetCurrentAction()
  return GetCurrentObjective().moves[MOVE_INDEX].actions[ACTION_INDEX]
end

local function FindNextObjective()
  OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
  if #OBJECTIVES < OBJECTIVE_INDEX then
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

  local action_time = current_objective.module.GetNextActionTime()

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
