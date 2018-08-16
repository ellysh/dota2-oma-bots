package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local swap_items = require("swap_items")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
