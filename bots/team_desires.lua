local units = require(
  GetScriptDirectory() .."/api/units")

function TeamThink()
  units.UpdateUnitList()
end
