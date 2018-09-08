local M = {}

---------------------------------

function M.pre_recovery()
  return false
end

function M.pre_defensive()
  return false
end

function M.pre_offensive()
  return false
end

function M.pre_farm()
  return true
end

---------------------------------

return M
