package.path = package.path .. ";../?.lua"

pcall(require, "luacov")
require("global_functions")

local team_desires = require("team_desires")
local luaunit = require("luaunit")

os.exit(luaunit.LuaUnit.run())
