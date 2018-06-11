local objectives = require(
  GetScriptDirectory() .."/dota2-api/api/objectives.lua")

function Think()
  objectives.Process()
end
