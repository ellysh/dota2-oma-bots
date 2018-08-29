package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local aggro_control = require("aggro_control")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
