function Think()
  if IsCourierAvailable() then
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
