package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local algorithms = require("algorithms")
local luaunit = require("luaunit")

function test_IsFacingLocation_30_succeed()
  local unit_data = {facing = 30, location = {x = 0, y = 0}}
  local location = {x = 0.866, y = 0.5}

  luaunit.assertTrue(algorithms.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_30_fails()
  local unit_data = {facing = 30, location = {x = 0, y = 0}}
  local location = {x = 0, y = 1}

  luaunit.assertFalse(algorithms.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_270_succeed()
  local unit_data = {facing = 270, location = {x = 0, y = 0}}
  local location = {x = 0, y = -1}

  luaunit.assertTrue(algorithms.IsFacingLocation(unit_data, location, 1))
end

os.exit(luaunit.LuaUnit.run())
