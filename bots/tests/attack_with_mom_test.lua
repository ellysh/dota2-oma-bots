package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local attack_with_mom = require("attack_with_mom")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
