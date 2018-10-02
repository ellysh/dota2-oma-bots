package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local attack_with_better_position = require("attack_with_better_position")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
