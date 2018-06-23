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

local OBJECTIVES = {
  "buy_and_use_courier",
  "buy_starting_items",
  "move_tier1_mid_lane"
}

local OBJECTIVE_INDEX = 1

-- Objective #1 - START

local function post_buy_and_use_courier()
  return IsCourierAvailable()
end

local function pre_buy_and_use_courier()
  return DotaTime() < 0 and not post_buy_and_use_courier()
end

local function buy_and_use_courier()
  GetBot():ActionImmediate_PurchaseItem('item_courier')

  GetBot():ActionQueue_UseAbility(GetBot():GetAbilityByName('item_courier'))
end

-- Objective #1 - END

local function buy_starting_items()
  GetBot():ActionImmediate_PurchaseItem('item_flask')
  GetBot():ActionImmediate_PurchaseItem('item_tango')
  GetBot():ActionImmediate_PurchaseItem('item_slippers')
  GetBot():ActionImmediate_PurchaseItem('item_circlet')
  GetBot():ActionImmediate_PurchaseItem('item_branches')
end

local function move_tier1_mid_lane()
  GetBot():ActionQueue_MoveToUnit(GetTower(GetTeam(), TOWER_MID_1))
end

function M.Process()
  if pre_buy_and_use_courier() then
    buy_and_use_courier()
  end

  if post_buy_and_use_courier() then
    OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
  end

--[[
  --TODO: Process one objective per M.Process() call. Remove the executed
  -- objective from the objectives.OBJECTIVES.

  functions.DoWithKeysAndElements(
    objectives.OBJECTIVES,
    function(name, details)
      if details["move"] == "nil" then
        return end

      move = ApplyCodeSnippets(moves.MOVES[ details["move"] ])
      load(move)()
    end)
]]--
end

-- Provide an access to local functions for unit tests only

return M
