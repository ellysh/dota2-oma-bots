local M = {}

local NEXT_ACTION_TIME = 0 -- float, seconds.microseconds

function M.SetNextActionDelay(delay)
  NEXT_ACTION_TIME = GameTime() + delay
end

function M.GetNextActionTime()
  return NEXT_ACTION_TIME
end

return M
