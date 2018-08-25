local chat = require(
  GetScriptDirectory() .."/utility/chat")

local function BuyCourier()
  if GetCourier(0) ~= nil then
    return end

  local bot = GetBot()
  local slot = bot:FindItemSlot("item_courier")
  local slot_type = bot:GetItemSlotType(slot)

  if slot_type ~= ITEM_SLOT_TYPE_MAIN
     and 0 < GetItemStockCount("item_courier") then

    bot:ActionImmediate_PurchaseItem("item_courier")
    return
  end

  if slot_type == ITEM_SLOT_TYPE_MAIN then
    bot:Action_UseAbility(bot:GetItemInSlot(slot))
  end
end

function Think()
  if DotaTime() < -85 then
    return end

  chat.PrintVersion(GetBot())

  BuyCourier()
end
