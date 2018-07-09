package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local prepare_for_match = require("prepare_for_match")
local luaunit = require("luaunit")

function test_pre_prepare_for_match_succeed()
  test_RefreshBot()

  TIME = -1
  luaunit.assertTrue(prepare_for_match.pre_prepare_for_match())
end

function test_post_prepare_for_match_succeed()
  test_RefreshBot()

  TIME = 1
  luaunit.assertFalse(prepare_for_match.pre_prepare_for_match())
end

function test_pre_buy_and_use_courier_succeed()
  test_RefreshBot()

  IS_COURIER_AVAILABLE = false
  luaunit.assertTrue(prepare_for_match.pre_buy_and_use_courier())
end

function test_post_buy_and_use_courier_succeed()
  test_RefreshBot()

  IS_COURIER_AVAILABLE = true
  luaunit.assertFalse(prepare_for_match.pre_buy_and_use_courier())
end

os.exit(luaunit.LuaUnit.run())
