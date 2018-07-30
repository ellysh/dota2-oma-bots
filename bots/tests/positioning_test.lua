package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local laning = require("positioning")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
