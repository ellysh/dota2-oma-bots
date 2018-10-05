local M = {}

M.BOTS_VERSION = "1.4.3"

M.INVENTORY_START_INDEX = 0
M.INVENTORY_END_INDEX = 8
M.INVENTORY_SIZE = 9

M.STASH_START_INDEX = 9
M.STASH_END_INDEX = 14
M.STASH_SIZE = 6

M.MAX_UNIT_SEARCH_RADIUS = 2000
M.MAX_UNIT_TARGET_RADIUS = 1600

M.TREE_SEARCH_RADIUS = 1000
M.CREEP_MAX_AGRO_RADIUS = 500
M.CREEP_MIN_AGRO_RADIUS = 300
M.NEAR_SPOT_RADIUS = 750

M.MIN_TP_BASE_RADIUS = 4000
M.BASE_RADIUS = 3000
M.MIN_TP_ENEMY_HERO_RADIUS = 1200

M.SAFE_TOWER_DISTANCE = 1000
M.BASE_CREEP_DISTANCE_NO_ENEMY_HERO = 300
M.BASE_CREEP_DISTANCE = 500
M.LASTHIT_CREEP_DISTANCE = 300
M.MAX_CREEP_DISTANCE = 710
M.MIN_CREEP_DISTANCE = 150
M.MIN_HERO_DISTANCE = 500
M.SAFE_HERO_DISTANCE = 1200
M.PRE_LASTHIT_CREEP_MAX_DISTANCE = 1200

M.BODY_BLOCK_FOUNTAIN_RADIANT_DISTANCE = 8600
M.BODY_BLOCK_FOUNTAIN_DIRE_DISTANCE = 9800

M.MAX_PURSUIT_INC_DISTANCE = 250
M.MAX_SAFE_INC_DISTANCE = 250

M.TANGO_USAGE_FROM_HG_DISTANCE = 1000

M.MOM_USAGE_FROM_ENEMY_HERO_DISTANCE = 400

M.MOTION_BUFFER_RANGE = 250

M.MAX_MELEE_ATTACK_RANGE = 310
M.MELEE_ATTACK_RANGE = 150

M.UNIT_LOW_HEALTH_LEVEL = 0.3 -- 30%
M.UNIT_LOW_HEALTH = 250
M.UNIT_MIN_TOWER_DIVE_HEALTH = 440
M.UNIT_MIN_TOWER_DIVE_HEALTH_WITH_HEALING = 300
M.UNIT_CRITICAL_HEALTH = 100
M.UNIT_HALF_HEALTH_LEVEL = 0.5 -- 50%
M.UNIT_MODERATE_HEALTH_LEVEL = 0.6 -- 60%
M.UNIT_FOUNTAIN_MAX_HEALTH = 0.85 -- 85%
M.UNIT_FOUNTAIN_MAX_MANA = 0.82 -- 82%

M.DROW_RANGER_ATTACK_POINT = 0.66
M.DROW_RANGER_TURN_TIME = 0.135 -- for 180 degrees

M.TURN_TARGET_MAX_DEGREE = 11.5

M.MAX_CREEPS_HP_DELTA = 300
M.MAX_CREEPS_HP_PULL = 1000

M.POWER_RATE_DEFENSE = 0.65
M.POWER_RATE_OFFENSE = 3

M.MAX_INCOMING_TOWER_DAMAGE = 100
M.MIN_INCOMING_TOWER_DAMAGE = 15

M.LAST_ATTACK_TIME_CORRECTION = 0.5

M.LAST_SEEN_LOCATION_MIN_DISTANCE = 0

M.CREEPS_AGGRO_COOLDOWN = 3

M.RESERVED_GOLD = 109

M.TIME_FIRST_WAVE_MEET = 22

M.MIN_HERO_LEVEL_FOR_AGRESSION = 6

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
