local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

function M.Print(string)
  --print(GameTime() .. ": " ..string .. "\n")
end

M.Print("OMA Bots version " .. constants.BOTS_VERSION ..
        " play in team " .. GetTeam())

return M
