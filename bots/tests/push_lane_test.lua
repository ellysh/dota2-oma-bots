package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local push_lane = require("push_lane")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
