local M = {}

M.INVENTORY_START_INDEX = 0
M.INVENTORY_END_INDEX = 8
M.INVENTORY_SIZE = 9

M.STASH_START_INDEX = 9
M.STASH_END_INDEX = 14
M.STASH_SIZE = 6

M.MAX_UNIT_SEARCH_RADIUS = 1600

M.TREE_SEARCH_RADIUS = 1000
M.CREEP_AGRO_RADIUS = 400
M.MIN_CREEP_DISTANCE = 250
M.BASE_CREEP_DISTANCE = 270
M.MAX_CREEP_DISTANCE = 700
M.MAX_CREEP_ATTACK_RANGE = 690
M.MAX_TOWER_ATTACK_RANGE = 700
M.MAX_HERO_ATTACK_RANGE = 700
M.MAX_MELEE_ATTACK_RANGE = 300

M.MAP_LOCATION_RADIUS = 200

M.UNIT_LOW_HEALTH_LEVEL = 0.3 -- 30%
M.UNIT_LOW_HEALTH = 250

M.DROW_RANGER_ATTACK_POINT = 0.7

return M
