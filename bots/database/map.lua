
local M = {}

M.MAP = {
  [TEAM_RADIANT] = {
    tower_tier_1_attack = Vector(-1544, -1408, 800),
    tower_tier_1_day_vision = Vector(-1544, -1408, 1900),
    tower_tier_1_night_vision = Vector(-1544, -1408, 800),
    high_ground = Vector(-1072, -913, 350),
    forest_bot = Vector(-905, -1523, 100),
    forest_top = Vector(-2240, -1230, 100),
    forest_back_bot = Vector(-1575, -1977, 100),
    forest_back_top = Vector(-2800, -1590, 100),
    fountain = Vector(-7000, -6500, 500),
    tp_tower_tier_1 = Vector(-1181, -1741, 100),
    first_body_block = Vector(-3709, -3307, 100),
    second_body_block = Vector(-1478, -1274, 100),
    tower_tier_1_rear = Vector(-2056, -1782, 800),
  },
  [TEAM_DIRE] = {
    tower_tier_1_attack = Vector(524, 652, 800),
    tower_tier_1_day_vision = Vector(524, 652, 1900),
    tower_tier_1_night_vision = Vector(524, 652, 800),
    high_ground = Vector(62, 99, 350),
    forest_bot = Vector(1209, 178, 100),
    forest_top = Vector(550, 1165, 100),
    forest_back_bot = Vector(1792, 700, 100),
    forest_back_top = Vector(1084, 1144, 100),
    fountain = Vector(6950, 6300, 500),
    tp_tower_tier_1 = Vector(530, 1138, 100),
    first_body_block = Vector(3357, 2878, 100),
    second_body_block = Vector(573, 463, 100),
    tower_tier_1_rear = Vector(984, 1163, 830),
  },
  [TEAM_NEUTRAL] = {
    river = Vector(-521, -375, 280),
  },
}

return M
