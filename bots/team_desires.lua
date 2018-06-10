local units = require(
  GetScriptDirectory() .."/dota2-api/units")

function TeamThink()
  units.UpdateUnitList()
end
