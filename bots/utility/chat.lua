local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local IS_CHAT_VERSION_DONE = false

function M.PrintVersion(unit)
  if IS_CHAT_VERSION_DONE then
    return end

  local team = functions.ternary(GetTeam() == 2, "Radiant", "Dire")

  unit:ActionImmediate_Chat("OMA Bots version " ..
    constants.BOTS_VERSION .. " play in team " .. team,
    true)

  IS_CHAT_VERSION_DONE = true
end

return M
