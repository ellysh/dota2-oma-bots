package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local functions = require("functions")
local luaunit = require("luaunit")

function test_IsFacingLocation_30_succeed()
  local unit_data = {facing = 30, location = {x = 0, y = 0}}
  local location = {x = 0.866, y = 0.5}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_30_fails()
  local unit_data = {facing = 30, location = {x = 0, y = 0}}
  local location = {x = 0, y = 1}

  luaunit.assertFalse(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_225_succeed()
  local unit_data = {facing = 225, location = {x = 0, y = 0}}
  local location = {x = -0.707106781, y = -0.707106781}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_315_succeed()
  local unit_data = {facing = 315, location = {x = 0, y = 0}}
  local location = {x = 0.707106781, y = -0.707106781}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_135_succeed()
  local unit_data = {facing = 135, location = {x = 0, y = 0}}
  local location = {x = -0.707106781, y = 0.707106781}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_45_succeed()
  local unit_data = {facing = 45, location = {x = 0, y = 0}}
  local location = {x = 0.707106781, y = 0.707106781}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_0_succeed()
  local unit_data = {facing = 0, location = {x = 0, y = 0}}
  local location = {x = 1, y = 0}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_90_succeed()
  local unit_data = {facing = 90, location = {x = 0, y = 0}}
  local location = {x = 0, y = 1}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_180_succeed()
  local unit_data = {facing = 180, location = {x = 0, y = 0}}
  local location = {x = -1, y = 0}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

function test_IsFacingLocation_270_succeed()
  local unit_data = {facing = 270, location = {x = 0, y = 0}}
  local location = {x = 0, y = -1}

  luaunit.assertTrue(functions.IsFacingLocation(unit_data, location, 1))
end

os.exit(luaunit.LuaUnit.run())
