package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local defend_tower = require("defend_tower")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
