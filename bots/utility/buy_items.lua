local map = require(
  GetScriptDirectory() .."/utility/map")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

local BOT = {}
local BOT_DATA = {}

function M.UpdateVariables()
  BOT = GetBot()
  BOT_DATA = common_algorithms.GetBotData()
end

---------------------------------

function M.pre_buy_items()
  return M.pre_buy_flask()
         or M.pre_buy_faerie_fire()
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
    if nil ~= BOT:GetItemInSlot(i) then
      return i
    end
  end

  return nil
end

local function GetEmptySlotInInventory(unit_data)
  for i = 0, 5 do
    if nil == BOT:GetItemInSlot(i) then
      return i
    end
  end

  return nil
end

function M.pre_put_item_in_inventory()
  return ((nil ~= GetFullSlotInBackpack(BOT_DATA))
          and (nil ~= GetEmptySlotInInventory(BOT_DATA)))
end

function M.post_put_item_in_inventory()
  return not M.pre_put_item_in_inventory()
end

function M.put_item_in_inventory()
  BOT:ActionImmediate_SwapItems(
    GetFullSlotInBackpack(BOT_DATA),
    GetEmptySlotInInventory(BOT_DATA))

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------

function M.pre_swap_items()
  local backpack_slot = GetFullSlotInBackpack(BOT_DATA)

  return BOT:FindItemSlot("item_branches") < 6
         and nil ~= backpack_slot
         and BOT:GetItemInSlot(backpack_slot):GetName() ~= "item_branches"
end

function M.post_swap_items()
  return not M.pre_swap_items()
end

function M.swap_items()
  BOT:ActionImmediate_SwapItems(
    BOT:FindItemSlot("item_branches"),
    GetFullSlotInBackpack(BOT_DATA))

  action_timing.SetNextActionDelay(0.1)
end

---------------------------------
local function IsEnoughGoldToBuy(item_name)
  return GetItemCost(item_name) <= BOT_DATA.gold
end

local function pre_buy_item(item_name)
  return not common_algorithms.DoesBotOrCourierHaveItem(item_name)
         and IsEnoughGoldToBuy(item_name)
end

function M.pre_buy_flask()
  return pre_buy_item("item_flask")
end

function M.post_buy_flask()
  return not M.pre_buy_flask()
end

function M.buy_flask()
  common_algorithms.BuyItem("item_flask")
end

---------------------------------

function M.pre_buy_faerie_fire()
  return pre_buy_item("item_faerie_fire")
         and BOT_DATA.level < 6
end

function M.post_buy_faerie_fire()
  return not M.pre_buy_faerie_fire()
end

function M.buy_faerie_fire()
  common_algorithms.BuyItem("item_faerie_fire")
end

---------------------------------

function M.pre_buy_tpscroll()
  return pre_buy_item("item_tpscroll")
end

function M.post_buy_tpscroll()
  return not M.pre_buy_tpscroll()
end

function M.buy_tpscroll()
  common_algorithms.BuyItem("item_tpscroll")
end

---------------------------------

function M.pre_buy_ring_of_protection()
  return pre_buy_item("item_ring_of_protection")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.post_buy_ring_of_protection()
  return not M.pre_buy_ring_of_protection()
end

function M.buy_ring_of_protection()
  common_algorithms.BuyItem("item_ring_of_protection")
end

---------------------------------

function M.pre_buy_sobi_mask()
  return pre_buy_item("item_sobi_mask")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_basilius")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_ring_of_aquila")
end

function M.post_buy_sobi_mask()
  return not M.pre_buy_sobi_mask()
end

function M.buy_sobi_mask()
  common_algorithms.BuyItem("item_sobi_mask")
end

---------------------------------

function M.pre_buy_boots()
  return pre_buy_item("item_boots")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_boots()
  return not M.pre_buy_boots()
end

function M.buy_boots()
  common_algorithms.BuyItem("item_boots")
end

---------------------------------

function M.pre_buy_gloves()
  return pre_buy_item("item_gloves")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_gloves()
  return not M.pre_buy_gloves()
end

function M.buy_gloves()
  common_algorithms.BuyItem("item_gloves")
end

---------------------------------

function M.pre_buy_boots_of_elves()
  return pre_buy_item("item_boots_of_elves")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_power_treads")
end

function M.post_buy_boots_of_elves()
  return not M.pre_buy_boots_of_elves()
end

function M.buy_boots_of_elves()
  common_algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_two_boots_of_elves()
  return common_algorithms.DoesBotOrCourierHaveItem("item_power_treads")
         and (2 * GetItemCost("item_boots_of_elves")) <= BOT_DATA.gold
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_boots_of_elves")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.post_buy_two_boots_of_elves()
  return not M.pre_buy_two_boots_of_elves()
end

function M.buy_two_boots_of_elves()
  common_algorithms.BuyItem("item_boots_of_elves")
  common_algorithms.BuyItem("item_boots_of_elves")
end

---------------------------------

function M.pre_buy_ogre_axe()
  return pre_buy_item("item_ogre_axe")
         and not common_algorithms.DoesBotOrCourierHaveItem(
                   "item_dragon_lance")
end

function M.post_buy_ogre_axe()
  return not M.pre_buy_ogre_axe()
end

function M.buy_ogre_axe()
  common_algorithms.BuyItem("item_ogre_axe")
end

---------------------------------

function M.pre_deliver_items()
  local courier_data = common_algorithms.GetCourierData()

  return 0 < BOT_DATA.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot(BOT_DATA, "fountain"))
end

function M.post_deliver_items()
  return not M.pre_deliver_items()
end

function M.deliver_items()
  local courier = GetCourier(0)

  BOT:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

-- Provide an access to local functions for unit tests only

return M
