package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local keep_equilibrium = require("keep_equilibrium")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
