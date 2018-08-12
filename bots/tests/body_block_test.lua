package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local body_block = require("body_block")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
