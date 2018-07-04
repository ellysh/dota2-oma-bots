package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local units = require("units")
local luaunit = require("luaunit")

function test_Process_first_objective_succeed()
  units.UpdateUnitList()
end

os.exit(luaunit.LuaUnit.run())
