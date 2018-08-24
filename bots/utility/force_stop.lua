local env = require(
  GetScriptDirectory() .."/utility/environment")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local M = {}

---------------------------------

function M.pre_force_stop()
  return algorithms.IsBotAlive()
end

function M.post_force_stop()
  return not M.pre_force_stop()
end

---------------------------------

function M.pre_stop()
  return true
end

function M.post_stop()
  return not M.pre_stop()
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
