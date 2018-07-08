local M = {}

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

---------------------------------

function M.pre_recovery()
  return false
end

function M.post_recovery()
  return true
end

---------------------------------

return M
