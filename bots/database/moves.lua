
local M = {}

M.MOVES = {

  is_beginning_of_match = "return DotaTime() < 0",

  buy_and_use_courier = "BotBuy('item_courier') BotUse(GetBot():GetAbilityByName('item_courier'))",

  buy_starting_items = "BotBuy('item_flask') BotBuy('item_tango') BotBuy('item_slippers') BotBuy('item_circlet') BotBuy('item_branches')",

  move_tier1_mid_lane = "BotMoveToUnit(GetTower(GetTeam(), TOWER_MID_1))",

}

return M