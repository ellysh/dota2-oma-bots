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

function test_pre_prepare_for_match_succeed()
  TIME = -1
  luaunit.assertTrue(objectives.pre_prepare_for_match())
end

function test_post_prepare_for_match_succeed()
  TIME = 1
  luaunit.assertFalse(objectives.pre_prepare_for_match())
end

function test_pre_buy_and_use_courier_succeed()
  IS_COURIER_AVAILABLE = false
  luaunit.assertTrue(objectives.pre_buy_and_use_courier())
end

function test_post_buy_and_use_courier_succeed()
  IS_COURIER_AVAILABLE = true
  luaunit.assertFalse(objectives.pre_buy_and_use_courier())
end


os.exit(luaunit.LuaUnit.run())
