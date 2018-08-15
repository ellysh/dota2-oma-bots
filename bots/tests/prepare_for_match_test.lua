package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local prepare_for_match = require("prepare_for_match")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
