
local M = {}

M.MAP = {
  [TEAM_RADIANT] = {
    tower_tier_1_attack = Vector(-1544, -1408, 800),
    tower_tier_1_day_vision = Vector(-1544, -1408, 1900),
    tower_tier_1_night_vision = Vector(-1544, -1408, 800),
    high_ground = Vector(-1073, -952, 350),
    forest_bot = Vector(-1129, -1744, 100),
    forest_top = Vector(-2240, -1230, 100),
    forest_back_bot = Vector(-1575, -1977, 100),
    forest_back_top = Vector(-2800, -1590, 100),
    fountain = Vector(-7000, -6500, 500),
    tp_tower_tier_1 = Vector(-1181, -1741, 100),
    start_body_block = Vector(-3972, -3471, 100),
    tower_tier_1_rear = Vector(-2056, -1782, 600),
  },
  [TEAM_DIRE] = {
    tower_tier_1_attack = Vector(524, 652, 800),
    tower_tier_1_day_vision = Vector(524, 652, 1900),
    tower_tier_1_night_vision = Vector(524, 652, 800),
    high_ground = Vector(46, 155, 350),
    forest_bot = Vector(1209, 178, 100),
    forest_top = Vector(550, 1165, 100),
    forest_back_bot = Vector(1792, 700, 100),
    forest_back_top = Vector(1084, 1144, 100),
    fountain = Vector(6950, 6300, 500),
    tp_tower_tier_1 = Vector(530, 1138, 100),
    start_body_block = Vector(3459, 2940, 100),
    tower_tier_1_rear = Vector(1118, 676, 500),
  },
  [TEAM_NEUTRAL] = {
    river = Vector(-521, -375, 280),
  },
}

return M
