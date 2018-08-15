package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local farm = require("farm")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
