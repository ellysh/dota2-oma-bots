package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local objectives = require("objectives")
local luaunit = require("luaunit")

function test_Process_first_objective_succeed()
  TIME = -1
  IS_COURIER_AVAILABLE = false
  objectives.Process()

  -- We need the second Process call to update the courier state
  IS_COURIER_AVAILABLE = true
  objectives.Process()
end

function test_Process_second_objective_succeed()
  IS_COURIER_AVAILABLE = true
  objectives.Process()
end

os.exit(luaunit.LuaUnit.run())
