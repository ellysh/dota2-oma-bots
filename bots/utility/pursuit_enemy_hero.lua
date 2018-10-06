local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local M = {}

---------------------------------

local function IsUnitLastSeenOnStairs(unit_data)
  local enemy_high_ground = map.GetEnemySpot("high_ground")

  return not env.ENEMY_HERO_DATA.is_visible
         and map.IsUnitInSpot(env.ENEMY_HERO_DATA, enemy_high_ground)
         and not IsLocationVisible(enemy_high_ground)
end

local function IsLastSeenLocationValid(unit_data)
  return unit_data.is_visible

         or constants.LAST_SEEN_LOCATION_MIN_DISTANCE
             < functions.GetUnitDistance(unit_data, env.BOT_DATA)

         or IsUnitLastSeenOnStairs(unit_data)
end

local LAST_ENEMY_HERO_DEATHS = 0

local function IsHeroDiedRecently(unit_data)
  local deaths = GetHeroDeaths(unit_data.player_id)

  if LAST_ENEMY_HERO_DEATHS < deaths then
    LAST_ENEMY_HERO_DEATHS = deaths
    return true
  else
    return false
  end
end

local function IsUnitTpOut(unit_data)
  -- TODO: Store a name of the current casting ability in the UNIT_LIST
  -- and check it here for TP out.

  return not unit_data.is_visible
         and unit_data.is_channeling
end

local function InvalidateEnemyHero()
  if not IsLastSeenLocationValid(env.ENEMY_HERO_DATA)
     or IsHeroDiedRecently(env.ENEMY_HERO_DATA)
     or IsUnitTpOut(env.ENEMY_HERO_DATA) then

    all_units.InvalidateUnit(env.ENEMY_HERO_DATA)
  end
end

function M.pre_pursuit_enemy_hero()
  if env.ENEMY_HERO_DATA ~= nil then
    InvalidateEnemyHero()
  end

  return env.ENEMY_HERO_DATA ~= nil
         and not env.IS_BOT_LOW_HP
         and algorithms.HasLevelForAggression(env.BOT_DATA)
         and algorithms.IsBotAlive()
         and algorithms.IsItemCastable(env.BOT_DATA, "item_flask")

         and (env.IS_ENEMY_HERO_LOW_HP

              or (env.ENEMY_HERO_DATA.is_flask_healing

                  and algorithms.IsBiggerThan(
                        env.BOT_DATA.health,
                        env.ENEMY_HERO_DATA.health,
                        100)))

         and (not env.DOES_TOWER_PROTECT_ENEMY
              or algorithms.IsTowerDiveReasonable(
                   env.BOT_DATA,
                   env.ENEMY_HERO_DATA))

         and not map.IsUnitInSpot(
                   env.ENEMY_HERO_DATA,
                   map.GetEnemySpot("tower_tier_1_rear_deep"))
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

function M.pre_move_enemy_hero()
  return moves.pre_move_enemy_hero()
end

function M.move_enemy_hero()
  if IsUnitLastSeenOnStairs(env.ENEMY_HERO_DATA) then
    env.BOT:Action_MoveDirectly(map.GetEnemySpot("high_ground"))
  else
    moves.move_enemy_hero()
  end
end

---------------------------------

return M
