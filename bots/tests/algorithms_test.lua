package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local algorithms = require("algorithms")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
