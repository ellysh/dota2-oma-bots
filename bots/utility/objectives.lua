local M = {}

local objectives = require(
  GetScriptDirectory() .."/database/objectives")

local moves = require(
  GetScriptDirectory() .."/database/moves")

local code_snippets = require(
  GetScriptDirectory() .."/database/code_snippets")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

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
  "move_tier1_mid_lane",
  "wait"
}

local OBJECTIVE_INDEX = 1

function M.post_buy_and_use_courier()
  -- TODO: Should we remove the single objectives here?

  return IsCourierAvailable()
end

function M.pre_buy_and_use_courier()
  return DotaTime() < 0 and not M.post_buy_and_use_courier()
end

function M.buy_and_use_courier()
  print("M.buy_and_use_courier()")

  GetBot():ActionImmediate_PurchaseItem('item_courier')

  GetBot():ActionQueue_UseAbility(GetBot():GetAbilityByName('item_courier'))
end

---------------------------------

local function IsItemPresent(item_name)
  local bot = GetBot()
  return functions.GetItem(bot, item_name, nil) ~= nil
end

function M.post_buy_starting_items()
  return IsItemPresent('item_flask')
         and IsItemPresent('item_tango')
         and IsItemPresent('item_slippers')
         and IsItemPresent('item_circlet')
         and IsItemPresent('item_branches')
end

function M.pre_buy_starting_items()
  return DotaTime() < 0 and not M.post_buy_starting_items()
end

function M.buy_starting_items()
  print("M.buy_starting_items()")

  GetBot():ActionImmediate_PurchaseItem('item_flask')
  GetBot():ActionImmediate_PurchaseItem('item_tango')
  GetBot():ActionImmediate_PurchaseItem('item_slippers')
  GetBot():ActionImmediate_PurchaseItem('item_circlet')
  GetBot():ActionImmediate_PurchaseItem('item_branches')
end

---------------------------------

function M.post_move_tier1_mid_lane()
  local target_distance = GetUnitToUnitDistance(
                            GetBot(),
                            GetTower(GetTeam(), TOWER_MID_1))

  return target_distance <= constants.MAP_LOCATION_RADIUS
end

function M.pre_move_tier1_mid_lane()
  return not M.post_move_tier1_mid_lane()
end

function M.move_tier1_mid_lane()
  print("M.move_tier1_mid_lane()")
  GetBot():Action_MoveToUnit(GetTower(GetTeam(), TOWER_MID_1))
end

---------------------------------

function M.post_wait()
  return false
end

function M.pre_wait()
  return true
end

function M.wait()
  GetBot():Action_Delay(100)
end

---------------------------------

function M.Process()
  local current_objective = OBJECTIVES[OBJECTIVE_INDEX]

  if M["pre_" .. current_objective]() then
    M[current_objective]()
  end

  if M["post_" .. current_objective]() then
    OBJECTIVE_INDEX = OBJECTIVE_INDEX + 1
  end
end

-- Provide an access to local functions for unit tests only

return M
