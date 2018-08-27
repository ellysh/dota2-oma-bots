local map = require(
  GetScriptDirectory() .."/utility/map")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

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

local function GetMaxHealthCreep(side)
  local creeps = functions.ternary(
    side == constants.SIDE["ENEMY"],
    algorithms.GetEnemyCreeps(
      env.BOT_DATA,
      env.BOT_DATA.attack_range),
    algorithms.GetAllyCreeps(
      env.BOT_DATA,
      env.BOT_DATA.attack_range))

  return functions.GetElementWith(
    creeps,
    algorithms.CompareMaxHealth,
    function(unit_data)
      return (side == constants.SIDE["ENEMY"])
             or (side == constants.SIDE["ALLY"]
                 and functions.GetRate(
                       unit_data.health,
                       unit_data.max_health)
                     < constants.UNIT_HALF_HEALTH_LEVEL)
    end)
end

function M.pre_attack_enemy_creep()
  local creep = GetMaxHealthCreep(constants.SIDE["ENEMY"])

  return creep ~= nil
         and constants.UNIT_HALF_HEALTH_LEVEL
             < functions.GetRate(creep.health, creep.max_health)
         and not algorithms.DoesTowerProtectUnit(creep)
         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_CREEPS
         and not env.IS_FOCUSED_BY_TOWER
end

function M.post_attack_enemy_creep()
  return not M.pre_attack_enemy_creep()
end

function M.attack_enemy_creep()
  local creep = GetMaxHealthCreep(constants.SIDE["ENEMY"])

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

--------------------------------

function M.pre_attack_ally_creep()
  local creep = GetMaxHealthCreep(constants.SIDE["ALLY"])

  return constants.MAX_CREEPS_HP_DELTA
           < (env.ALLY_CREEPS_HP - env.ENEMY_CREEPS_HP)
         and creep ~= nil
         and not algorithms.DoesTowerProtectUnit(creep)
         and not env.IS_FOCUSED_BY_ENEMY_HERO
         and not env.IS_FOCUSED_BY_CREEPS
         and not env.IS_FOCUSED_BY_TOWER
end

function M.post_attack_ally_creep()
  return not M.pre_attack_ally_creep()
end

function M.attack_ally_creep()
  local creep = GetMaxHealthCreep(constants.SIDE["ALLY"])

  algorithms.AttackUnit(env.BOT_DATA, creep, false)
end

--------------------------------

function M.stop_attack()
  if not all_units.IsUnitAttack(env.BOT_DATA)
     or not all_units.IsAttackDone(env.BOT_DATA) then
    return end

  env.BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_attack_enemy_hero()
  return env.ENEMY_HERO_DATA ~= nil
         and not env.DOES_TOWER_PROTECT_ENEMY
         and functions.GetUnitDistance(env.BOT_DATA, env.ENEMY_HERO_DATA)
             <= env.BOT_DATA.attack_range
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  algorithms.AttackUnit(env.BOT_DATA, env.ENEMY_HERO_DATA, true)
end

---------------------------------

function M.pre_use_silence()
  local ability = env.BOT:GetAbilityByName("drow_ranger_wave_of_silence")

  return env.ENEMY_HERO_DATA ~= nil
         and not env.ENEMY_HERO_DATA.is_silenced
         and not env.BOT_DATA.is_silenced
         and ability:IsFullyCastable()
         and functions.GetUnitDistance(env.BOT_DATA, env.ENEMY_HERO_DATA)
               <= ability:GetCastRange()
         and not env.DOES_TOWER_PROTECT_ENEMY
end

function M.post_use_silence()
  return not M.pre_use_silence()
end

function M.use_silence()
  local ability = env.BOT:GetAbilityByName("drow_ranger_wave_of_silence")

  env.BOT:Action_UseAbilityOnLocation(ability, env.ENEMY_HERO_DATA.location)
end

---------------------------------

function M.pre_deliver_items()
  local courier_data = algorithms.GetCourierData()

  return 0 < env.BOT_DATA.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot("fountain"))
end

function M.post_deliver_items()
  return not M.pre_deliver_items()
end

function M.deliver_items()
  local courier = GetCourier(0)

  env.BOT:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

-- Provide an access to local functions for unit tests only

return M
