package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local buy_items = require("buy_items")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
