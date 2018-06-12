local M = {}

local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local moves = require(
  GetScriptDirectory() .."/database/moves")

local code_snippets = require(
  GetScriptDirectory() .."/database/code_snippets")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local function ApplyCodeSnippets(code)
  functions.DoWithKeysAndElements(
    code_snippets.CODE_SNIPPETS,
    function(name, snippet)
      code = string.gsub(code, name, snippet)
    end)
  return code
end

function M.Process()
  functions.DoWithKeysAndElements(
    objectives.OBJECTIVES,
    function(name, details)
      if details["move"] == "nil" then
        return end

      move = ApplyCodeSnippets(moves.MOVES[details["move"]])
      load(move)()
    end)
end

-- Provide an access to local functions for unit tests only

return M
