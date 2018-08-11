package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local base_recovery = require("base_recovery")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
