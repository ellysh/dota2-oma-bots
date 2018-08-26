local M = {}

M.BOTS_VERSION = "1.0"

M.INVENTORY_START_INDEX = 0
M.INVENTORY_END_INDEX = 8
M.INVENTORY_SIZE = 9

M.STASH_START_INDEX = 9
M.STASH_END_INDEX = 14
M.STASH_SIZE = 6

M.MAX_UNIT_SEARCH_RADIUS = 2000
M.MAX_UNIT_TARGET_RADIUS = 1600

M.TREE_SEARCH_RADIUS = 1000
M.CREEP_AGRO_RADIUS = 400
M.NEAR_SPOT_RADIUS = 750

M.MIN_TP_BASE_RADIUS = 4000
M.BASE_RADIUS = 3000
M.MIN_TP_ENEMY_HERO_RADIUS = 1200

M.MIN_CREEP_DISTANCE = 250
M.BASE_CREEP_DISTANCE = 270
M.MAX_CREEP_DISTANCE = 710

M.TANGO_USAGE_FROM_HG_DISTANCE = 1000

M.MAX_CREEP_ATTACK_RANGE = 690
M.MAX_TOWER_ATTACK_RANGE = 730
M.MAX_HERO_ATTACK_RANGE = 765 -- with the dragon lance item
M.MAX_MELEE_ATTACK_RANGE = 310

M.UNIT_LOW_HEALTH_LEVEL = 0.3 -- 30%
M.UNIT_LOW_HEALTH = 250
M.UNIT_HALF_HEALTH_LEVEL = 0.5 -- 50%
M.UNIT_FOUNTAIN_MAX_HEALTH = 0.85 -- 85%
M.UNIT_FOUNTAIN_MAX_MANA = 0.82 -- 82%

M.DROW_RANGER_ATTACK_POINT = 0.71
M.DROW_RANGER_TURN_TIME = 0.135 -- for 180 degrees

M.TURN_TARGET_MAX_DEGREE = 11.5

M.MAX_CREEPS_HP_DELTA = 300

M.POWER_RATE_DEFENSE = 0.65
M.POWER_RATE_OFFENSE = 3

M.MAX_INCOMING_TOWER_DAMAGE = 100
M.MIN_INCOMING_TOWER_DAMAGE = 15

M.RESERVED_GOLD = 109

M.SIDE = {
  ENEMY = {},
  ALLY = {},
}

M.DIRECTION = {
  FRONT = {},
  BACK = {},
  ANY = {},
}

return M
