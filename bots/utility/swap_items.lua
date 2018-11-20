local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_swap_items()
  return algorithms.IsBotAlive()
end

---------------------------------

function M.pre_swap_flask_wraith_band()
  local flask_slot = env.BOT:FindItemSlot("item_flask")
  local wb_slot = env.BOT:FindItemSlot("item_wraith_band")

  return env.BOT:GetItemSlotType(flask_slot) == ITEM_SLOT_TYPE_BACKPACK
         and env.BOT:GetItemSlotType(wb_slot) == ITEM_SLOT_TYPE_MAIN
end

function M.swap_flask_wraith_band()
  local flask_slot = env.BOT:FindItemSlot("item_flask")
  local wb_slot = env.BOT:FindItemSlot("item_wraith_band")

  env.BOT:ActionImmediate_SwapItems(flask_slot, wb_slot)

  action_timing.SetNextActionDelay(0.05)
end

----------------------------------

local function GetFullSlotInBackpack(unit_data)
  for i = 6, 8 do
    if nil ~= env.BOT:GetItemInSlot(i) then
      return i
    end
  end

  return nil
end

local function GetEmptySlotInInventory(unit_data)
  for i = 0, 5 do
    if nil == env.BOT:GetItemInSlot(i) then
      return i
    end
  end

  return nil
end

function M.pre_put_item_in_inventory()
  return ((nil ~= GetFullSlotInBackpack(env.BOT_DATA))
          and (nil ~= GetEmptySlotInInventory(env.BOT_DATA)))
end

function M.put_item_in_inventory()
  env.BOT:ActionImmediate_SwapItems(
    GetFullSlotInBackpack(env.BOT_DATA),
    GetEmptySlotInInventory(env.BOT_DATA))

  action_timing.SetNextActionDelay(0.05)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
