
local M = {}

M.OBJECTIVES = {

  start_match = {
    move = "is_beginning_of_match",
    dependency = "nil",
    timeout = -1,
  },

  prepare_courer = {
    move = "buy_and_use_courier",
    dependency = "start_match",
    timeout = -1,
  },

  buy_starting_items = {
    move = "buy_starting_items",
    dependency = "prepare courer",
    timeout = -1,
  },

  move_tier1_mid_lane = {
    move = "move_tier1_mid_lane",
    dependency = "buy_starting_items",
    timeout = -1,
  },

}

return M
