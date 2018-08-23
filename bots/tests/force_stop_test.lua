package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local force_stop = require("force_stop")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
