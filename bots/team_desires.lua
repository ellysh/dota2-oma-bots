local units = require(
  GetScriptDirectory() .."/dota2-api/api/units")

function TeamThink()
  units.UpdateUnitList()
end
