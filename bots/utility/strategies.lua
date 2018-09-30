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

local function DoesUnitHasAdvantage(unit_data, target_data)
  return unit_data ~= nil
         and target_data ~= nil
         and (algorithms.IsBiggerThan(
                unit_data.attack_damage,
                target_data.attack_damage,
                50)
              or algorithms.IsBiggerThan(
                   unit_data.health,
                   target_data.health,
                   300)
              or algorithms.IsBiggerThan(
                   unit_data.speed,
                   target_data.speed,
                   40)
              or algorithms.IsBiggerThan(
                   unit_data.attack_speed,
                   target_data.attack_speed,
                   20)
              or algorithms.IsBiggerThan(
                   unit_data.attack_range,
                   target_data.attack_range,
                   100))
end

local function IsEnemyUnitOnHighGround()
  return (env.ENEMY_HERO_DATA ~= nil
          and map.IsUnitInEnemyTowerAttackRange(env.ENEMY_HERO_DATA))

         or nil ~= algorithms.GetCreepWith(
                     env.BOT_DATA,
                     constants.SIDE["ENEMY"],
                     nil,
                     map.IsUnitInEnemyTowerAttackRange)
end

function M.pre_defensive()
  return DoesCreepMeet()
         and not env.IS_ENEMY_HERO_LOW_HP
         and (DoesUnitHasAdvantage(env.ENEMY_HERO_DATA, env.BOT_DATA)
              or IsEnemyUnitOnHighGround())
end

---------------------------------

function M.pre_offensive()
  return DoesCreepMeet()
         and (env.ENEMY_HERO_DATA == nil
              or env.IS_ENEMY_HERO_LOW_HP
              or DoesUnitHasAdvantage(env.BOT_DATA, env.ENEMY_HERO_DATA))
end

---------------------------------

function M.pre_farm()
  return true
end

---------------------------------

return M
