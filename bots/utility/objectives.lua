local M = {}

local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local moves = require(
  GetScriptDirectory() .."/database/moves")

local code_snippets = require(
  GetScriptDirectory() .."/database/code_snippets")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

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
