package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local item_recovery = require("item_recovery")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
