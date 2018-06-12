package.path = package.path .. ";../api/?.lua"

pcall(require, "luacov")
require("global_functions")

local units = require("units")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
