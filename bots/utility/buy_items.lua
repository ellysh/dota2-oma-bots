local map = require(
  GetScriptDirectory() .."/utility/map")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_buy_items()
  return M.pre_buy_flask()
         or M.pre_buy_ring_of_protection()
         or M.pre_buy_sobi_mask()
         or M.pre_buy_boots()
         or M.pre_buy_gloves()
         or M.pre_buy_boots_of_elves()
         or M.pre_buy_tpscroll()
         or M.pre_deliver_items()
         or M.pre_buy_two_boots_of_elves()
         or M.pre_buy_ogre_axe()
         or M.pre_swap_items()
         or M.pre_put_item_in_inventory()
end

function M.post_buy_items()
  return not M.pre_buy_items()
end

---------------------------------

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

function M.post_put_item_in_inventory()
  return not M.pre_put_item_in_inventory()
end

function M.put_item_in_inventory()
  env.BOT:ActionImmediate_SwapItems(
    GetFullSlotInBackpack(env.BOT_DATA),
    GetEmptySlotInInventory(env.BOT_DATA))

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------

function M.pre_swap_items()
  local backpack_slot = GetFullSlotInBackpack(env.BOT_DATA)

  return env.BOT:FindItemSlot("item_branches") < 6
         and nil ~= backpack_slot
         and env.BOT:GetItemInSlot(backpack_slot):GetName() ~= "item_branches"
end

function M.post_swap_items()
  return not M.pre_swap_items()
end

function M.swap_items()
  env.BOT:ActionImmediate_SwapItems(
    env.BOT:FindItemSlot("item_branches"),
    GetFullSlotInBackpack(env.BOT_DATA))

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------
local function IsEnoughGoldToBuy(item_name)
  return GetItemCost(item_name) <= env.BOT_DATA.gold
end

local function pre_buy_item(item_name)
  return not algorithms.DoesBotOrCourierHaveItem(item_name)
         and IsEnoughGoldToBuy(item_name)
end

function M.pre_buy_flask()
  return pre_buy_item("item_flask")
end

function M.post_buy_flask()
  return not M.pre_buy_flask()
end

function M.buy_flask()
  algorithms.BuyItem("item_flask")
end

---------------------------------

function M.pre_buy_tpscroll()
  return pre_buy_item("item_tpscroll")
end

function M.post_buy_tpscroll()
  return not M.pre_buy_tpscroll()
end

function M.buy_tpscroll()
  algorithms.BuyItem("item_tpscroll")
end

---------------------------------

function M.pre_buy_ring_of_protection()
  return pre_buy_item("item_ring_of_protection")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.post_buy_ring_of_protection()
  return not M.pre_buy_ring_of_protection()
end

function M.buy_ring_of_protection()
  algorithms.BuyItem("item_ring_of_protection")
end

---------------------------------

function M.pre_buy_sobi_mask()
  return pre_buy_item("item_sobi_mask")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.post_buy_sobi_mask()
  return not M.pre_buy_sobi_mask()
end

function M.buy_sobi_mask()
  algorithms.BuyItem("item_sobi_mask")
end

---------------------------------

function M.pre_buy_boots()
  return pre_buy_item("item_boots")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_boots()
  return not M.pre_buy_boots()
end

function M.buy_boots()
  algorithms.BuyItem("item_boots")
end

---------------------------------

function M.pre_buy_gloves()
  return pre_buy_item("item_gloves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_gloves()
  return not M.pre_buy_gloves()
end

function M.buy_gloves()
  algorithms.BuyItem("item_gloves")
end

---------------------------------

function M.pre_buy_boots_of_elves()
  return pre_buy_item("item_boots_of_elves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_boots_of_elves()
  return not M.pre_buy_boots_of_elves()
end

function M.buy_boots_of_elves()
  algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_two_boots_of_elves()
  return algorithms.DoesBotOrCourierHaveItem("item_power_treads")
         and (2 * GetItemCost("item_boots_of_elves")) <= env.BOT_DATA.gold
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_boots_of_elves")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.post_buy_two_boots_of_elves()
  return not M.pre_buy_two_boots_of_elves()
end

function M.buy_two_boots_of_elves()
  algorithms.BuyItem("item_boots_of_elves")
  algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_ogre_axe()
  return pre_buy_item("item_ogre_axe")
         and not algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.post_buy_ogre_axe()
  return not M.pre_buy_ogre_axe()
end

function M.buy_ogre_axe()
  algorithms.BuyItem("item_ogre_axe")
end

---------------------------------

function M.pre_deliver_items()
  local courier_data = algorithms.GetCourierData()

  return 0 < env.BOT_DATA.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot(env.BOT_DATA, "fountain"))
end

function M.post_deliver_items()
  return not M.pre_deliver_items()
end

function M.deliver_items()
  local courier = GetCourier(0)

  env.BOT:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

-- Provide an access to local functions for unit tests only

return M
