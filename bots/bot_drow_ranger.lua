local objectives = require(
  GetScriptDirectory() .."/utility/objectives")

function Think()
  objectives.Process()
end
