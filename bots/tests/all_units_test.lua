package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local all_units = require("all_units")
local luaunit = require("luaunit")

function test_Process_first_objective_succeed()
  all_units.UpdateUnitList()
end

os.exit(luaunit.LuaUnit.run())
