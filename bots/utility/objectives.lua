local M = {}

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

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
      {move = "buy_starting_items",
       actions = {
         {action = "buy_starting_items"},
       }
      },
    },
  },
  [2] = {
    objective = "laning",
    module = require(GetScriptDirectory() .."/utility/laning"),
    moves = {
      {move = "lasthit_enemy_creep",
       actions = {
         {action = "lasthit_enemy_creep"},
       }
      },
      {move = "deny_ally_creep",
       actions = {
         {action = "deny_ally_creep"},
       }
      },
      {move = "harras_enemy_hero",
       actions = {
         {action = "harras_enemy_hero"},
       }
      },
      {move = "evasion",
       actions = {
         {action = "evasion"},
       }
      },
      {move = "move_mid_front_lane",
       actions = {
         {action = "move_mid_front_lane"},
       }
      },
      {move = "positioning",
       actions = {
         {action = "positioning"},
       }
      },
      {move = "turn",
       actions = {
         {action = "turn"},
       }
      },
      {move = "stop",
       actions = {
         {action = "stop"},
       }
      },
    },
  },
  [3] = {
    objective = "recovery",
    module = require(GetScriptDirectory() .."/utility/recovery"),
    moves = {
      {move = "move_base",
       actions = {
         {action = "move_base"},
       }
      },
      {move = "heal_tango",
       actions = {
         {action = "heal_tango"},
       }
      },
      {move = "heal_flask",
       actions = {
         {action = "heal_flask"},
       }
      },
      {move = "move_shrine",
       actions = {
         {action = "move_shrine"},
       }
      },
      {move = "tp_base",
       actions = {
         {action = "tp_base"},
       }
      },
    },
  },
  [4] = {
    objective = "kill_enemy_hero",
    module = require(GetScriptDirectory() .."/utility/kill_enemy_hero"),
    moves = {
      {move = "attack_enemy_hero",
       actions = {
         {action = "attack_enemy_hero"},
       }
      },
    }
  }
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
