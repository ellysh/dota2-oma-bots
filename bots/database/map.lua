
local M = {}

M.MAP = {
  [TEAM_RADIANT] = {
    tower_tier_1_attack = Vector(-1544, -1408, 800),
    tower_tier_1_day_vision = Vector(-1544, -1408, 1900),
    tower_tier_1_night_vision = Vector(-1544, -1408, 800),
    high_ground = Vector(-1072, -913, 350),
    high_ground_safe = Vector(-1340, -1154, 100),
    forest_bot = Vector(-1150, -1730, 100),
    forest_top = Vector(-2240, -1230, 100),
    forest_back_bot = Vector(-1575, -1977, 100),
    forest_back_top = Vector(-2800, -1590, 100),
    forest_deep_bot = Vector(-2725, -2727, 100),
    forest_deep_top = Vector(-4075, -2640, 100),
    fountain = Vector(-7000, -6500, 500),
    tp_tower_tier_1 = Vector(-1181, -1741, 100),
    first_body_block = Vector(-3709, -3307, 100),
    second_body_block = Vector(-1478, -1274, 100),
    second_body_block_area = Vector(-1544, -1408, 900),
    tower_tier_1_rear_deep = Vector(-2400, -2040, 500),
    between_tier_1_tear_2 = Vector(-2562, -2062, 1030),
    river = Vector(-598, -472, 260),
  },
  [TEAM_DIRE] = {
    tower_tier_1_attack = Vector(524, 652, 800),
    tower_tier_1_day_vision = Vector(524, 652, 1900),
    tower_tier_1_night_vision = Vector(524, 652, 800),
    high_ground = Vector(62, 99, 350),
    high_ground_safe = Vector(465, 383, 100),
    forest_bot = Vector(1209, 178, 100),
    forest_top = Vector(550, 1165, 100),
    forest_back_bot = Vector(1792, 700, 100),
    forest_back_top = Vector(1084, 1144, 100),
    forest_deep_bot = Vector(3076, 1415, 100),
    forest_deep_top = Vector(1773, 2245, 100),
    fountain = Vector(6950, 6300, 500),
    tp_tower_tier_1 = Vector(530, 1138, 100),
    first_body_block = Vector(3357, 2878, 100),
    second_body_block = Vector(573, 463, 100),
    second_body_block_area = Vector(524, 652, 900),
    tower_tier_1_rear_deep = Vector(1470, 1100, 450),
    between_tier_1_tear_2 = Vector(1606, 1236, 1040),
    river = Vector(-437, -313, 250),
  },
  [TEAM_NEUTRAL] = {
    river = Vector(-521, -375, 280),
  },
}

return M
