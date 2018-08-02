package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local attack_unit = require("attack_unit")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
