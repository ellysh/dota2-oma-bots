local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local map = require(
  GetScriptDirectory() .."/utility/map")

local base_recovery = require(
  GetScriptDirectory() .."/utility/base_recovery")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

local function DoesCreepMeet()
  return 25 < DotaTime()
end

function M.pre_buy()
  return DoesCreepMeet()
end

---------------------------------

function M.pre_recovery()
  return DoesCreepMeet()
         and (not algorithms.IsBotAlive()
              or env.IS_BOT_LOW_HP
              or env.IS_BASE_RECOVERY
              or base_recovery.pre_restore_hp_on_base())
end

local function IsEnemyUnitOnAllyHighGround()
  return (env.ENEMY_HERO_DATA ~= nil
          and (map.IsUnitInEnemyTowerAttackRange(env.ENEMY_HERO_DATA)
               or map.IsUnitBetweenEnemyTowers(env.ENEMY_HERO_DATA)))

         or nil ~= algorithms.GetCreepWith(
                     env.BOT_DATA,
                     constants.SIDE["ENEMY"],
                     nil,
                     function(unit_data)
                       return map.IsUnitInEnemyTowerAttackRange(unit_data)
                              or map.IsUnitBetweenEnemyTowers(unit_data)
                     end)
end

function M.pre_defensive()
  return DoesCreepMeet()
         and not env.IS_ENEMY_HERO_LOW_HP
         and ((env.DOES_ENEMY_HERO_HAVE_ADVANTAGE
               and not env.DOES_BOT_HAVE_ADVANTAGE)

              or IsEnemyUnitOnAllyHighGround()

              or (env.ALLY_TOWER_DATA ~= nil
                  and 0 < algorithms.GetTotalIncomingDamage(
                            env.ALLY_TOWER_DATA)))
end

---------------------------------

function M.pre_offensive()
  return DoesCreepMeet()
         and (env.ENEMY_HERO_DATA == nil
              or env.IS_ENEMY_HERO_LOW_HP

              or (env.DOES_BOT_HAVE_ADVANTAGE
                  and not env.DOES_ENEMY_HERO_HAVE_ADVANTAGE)

              or (env.ENEMY_TOWER_DATA ~= nil
                  and env.ENEMY_TOWER_DISTANCE
                      <= algorithms.GetAttackRange(
                           env.BOT_DATA,
                           env.ENEMY_TOWER_DATA,
                           false)))
end

---------------------------------

function M.pre_farm()
  return true
end

---------------------------------

return M
