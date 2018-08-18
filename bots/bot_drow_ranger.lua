local objectives = require(
  GetScriptDirectory() .."/utility/objectives")

function Think()
  if DotaTime() < -85 then
    return end

  objectives.Process()
end
