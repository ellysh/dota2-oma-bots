package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local recovery = require("recovery")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
