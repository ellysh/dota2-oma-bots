local M = {}

M.INVENTORY_START_INDEX = 0
M.INVENTORY_END_INDEX = 8
M.INVENTORY_SIZE = 9

M.STASH_START_INDEX = 9
M.STASH_END_INDEX = 14
M.STASH_SIZE = 6

M.MAP_LOCATION_RADIUS = 300

M.DEFAULT_ABILITY_USAGE_RADIUS = 600
M.MAX_ABILITY_USAGE_RADIUS = 1600

M.CREEP_AGRO_RADIUS = 510
M.MIN_CREEP_DISTANCE = 250
M.MAX_CREEP_DISTANCE = 710
M.MAX_CREEP_ATTACK_RANGE = 690
M.MAX_TOWER_ATTACK_RANGE = 730
M.MAX_HERO_ATTACK_RANGE = 710
M.MAX_MELEE_ATTACK_RANGE = 310

M.UNIT_LOW_HEALTH_LEVEL = 0.3 -- 30%
M.UNIT_LOW_HEALTH = 250

return M
