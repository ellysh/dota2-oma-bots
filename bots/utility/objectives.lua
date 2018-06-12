local M = {}

local objectives = require(
  GetScriptDirectory() .."/dota2-api/database/lua/objectives")

local moves = require(
  GetScriptDirectory() .."/dota2-api/database/lua/moves")

local code_snippets = require(
  GetScriptDirectory() .."/dota2-api/database/lua/code_snippets")

local functions = require(
  GetScriptDirectory() .."/dota2-api/api/functions")

function M.Process()
  functions.DoWithKeysAndElements(
    objectives.OBJECTIVES,
    function(name, details)
      print(name)
    end
  )
end

-- Provide an access to local functions for unit tests only

return M
