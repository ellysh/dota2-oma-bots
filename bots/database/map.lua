
local M = {}

M.MAP = {
  [TEAM_RADIANT] = {
    tower_tier_1_attack = Vector(-1563, -1408, 710),
    tower_tier_1_day_vision = Vector(-1563, -1408, 1900),
    tower_tier_1_night_vision = Vector(-1563, -1408, 800),
    high_ground = Vector(-1073, 952, 350),
    forest_bot = Vector(-908, -1541, 140),
    forest_top = Vector(-2045, -1000, 100),
  },
  [TEAM_DIRE] = {
    tower_tier_1_attack = Vector(531, 653, 710),
    tower_tier_1_day_vision = Vector(531, 653, 1900),
    tower_tier_1_night_vision = Vector(531, 653, 800),
    high_ground = Vector(46, 155, 350),
    forest_bot = Vector(1024, 124, 70),
    forest_top = Vector(550, 1165, 100),
  },
  [TEAM_NEUTRAL] = {
    river = Vector(-521, -375, 280),
  },
}

return M
