local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

--------------------------------

function M.pre_attack_enemy_creep()
  local creep = algorithms.GetCreepWith(
                  env.BOT_DATA,
                  constants.SIDE["ENEMY"],
                  algorithms.CompareMaxHealth,
                  nil)

  return creep ~= nil
         and constants.UNIT_HALF_HEALTH_LEVEL
             < functions.GetRate(creep.health, creep.max_health)
         and env.ALLY_CREEP_FRONT_DATA ~= nil
         and not algorithms.DoesTowerProtectUnit(creep)
end

function M.attack_enemy_creep()
  local creep = algorithms.GetCreepWith(
                  env.BOT_DATA,
                  constants.SIDE["ENEMY"],
                  algorithms.CompareMaxHealth,
                  nil)

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

--------------------------------

local function GetTargetableAllyCreep()
  return algorithms.GetCreepWith(
           env.BOT_DATA,
           constants.SIDE["ALLY"],
           algorithms.CompareMaxHealth,
           function(unit_data)
             return functions.GetRate(
                      unit_data.health,
                      unit_data.max_health)
                    < constants.UNIT_HALF_HEALTH_LEVEL
           end)
end

function M.pre_attack_ally_creep()
  local creep = GetTargetableAllyCreep()

  return creep ~= nil
         and not algorithms.DoesTowerProtectUnit(creep)
end

function M.attack_ally_creep()
  local creep = GetTargetableAllyCreep()

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

--------------------------------

function M.stop_attack()
  if not algorithms.IsUnitAttack(env.BOT_DATA)
     or not algorithms.IsAttackDone(env.BOT_DATA) then
    return end

  env.BOT:Action_ClearActions(true)
end

---------------------------------

local function IsAttackUnderTowerSafe()
  return env.ALLY_CREEP_FRONT_DATA ~= nil
         and constants.TOWER_AGGRO_RADIUS < env.ENEMY_TOWER_DISTANCE
end

function M.pre_attack_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_HERO_DATA.is_visible
         and (not env.DOES_TOWER_PROTECT_ENEMY
              or IsAttackUnderTowerSafe()
              or algorithms.IsTowerDiveReasonable(
                   env.BOT_DATA,
                   env.ENEMY_HERO_DATA))
end

function M.attack_enemy_hero()
  algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_HERO_DATA, true)
end

---------------------------------

function M.pre_use_silence()
  local ability = env.BOT:GetAbilityByName("drow_ranger_wave_of_silence")

  return env.ENEMY_HERO_DATA ~= nil
         and env.ENEMY_HERO_DATA.is_visible
         and ability:IsFullyCastable()
         and env.ENEMY_HERO_DISTANCE <= ability:GetCastRange()
end

function M.use_silence()
  local ability = env.BOT:GetAbilityByName("drow_ranger_wave_of_silence")

  env.BOT:Action_UseAbilityOnLocation(ability, env.ENEMY_HERO_DATA.location)
end

---------------------------------

function M.pre_move_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil

         and env.ENEMY_HERO_DISTANCE
             <= algorithms.GetAttackRange(
                  env.BOT_DATA,
                  env.ENEMY_HERO_DATA,
                  true)
                + constants.MAX_PURSUIT_INC_DISTANCE
end

function M.move_enemy_hero()
  env.BOT:Action_MoveDirectly(env.ENEMY_HERO_DATA.location)
end

---------------------------------

function M.pre_deliver_items()
  local courier_data = algorithms.GetCourierData()

  return 0 < env.BOT_DATA.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot("fountain"))
end

function M.deliver_items()
  local courier = GetCourier(0)

  env.BOT:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

-- Provide an access to local functions for unit tests only

return M
