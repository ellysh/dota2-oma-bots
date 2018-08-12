local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local M = {}

---------------------------------

function M.pre_restore_hp_on_base()
  return env.BOT:HasModifier("modifier_fountain_aura_buff")
         and (functions.GetRate(env.BOT_DATA.health, env.BOT_DATA.max_health)
              < constants.UNIT_FOUNTAIN_MAX_HEALTH
              or functions.GetRate(env.BOT_DATA.mana, env.BOT_DATA.max_mana)
                 < constants.UNIT_FOUNTAIN_MAX_MANA)
end

function M.post_restore_hp_on_base()
  return not M.pre_restore_hp_on_base()
end

function M.restore_hp_on_base()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_base_recovery()
  return ((algorithms.IsUnitLowHp(env.BOT_DATA)
           and (not env.BOT_DATA.is_healing
                or algorithms.IsFocusedByEnemyHero(env.BOT_DATA)))

          or M.pre_restore_hp_on_base()

          or (functions.GetRate(env.BOT_DATA.health, env.BOT_DATA.max_health)
              < constants.UNIT_HALF_HEALTH_LEVEL
              and functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)
                  < constants.BASE_RADIUS))
end

function M.post_base_recovery()
  return not M.pre_base_recovery()
end

---------------------------------

function M.pre_move_base()

  return (not (algorithms.IsUnitMoving(env.BOT_DATA)
              and env.BOT:IsFacingLocation(env.FOUNTAIN_SPOT, 30)))
          or (functions.GetRate(env.BOT_DATA.health, env.BOT_DATA.max_health)
              < constants.UNIT_HALF_HEALTH_LEVEL
              and functions.GetDistance(
                    env.FOUNTAIN_SPOT,
                    env.BOT_DATA.location)
                  < constants.BASE_RADIUS)
end

function M.post_move_base()
  return not M.pre_move_base()
end

function M.move_base()
  env.BOT:Action_MoveToLocation(env.FOUNTAIN_SPOT)

  if functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)
     < constants.BASE_RADIUS
     and not env.BOT:HasModifier("modifier_fountain_aura_buff") then

    action_timing.SetNextActionDelay(1.5)
  end
end

---------------------------------

function M.pre_deliver_items()
  local courier_data = algorithms.GetCourierData()

  return 0 < env.BOT_DATA.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot(env.BOT_DATA, "fountain"))
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

---------------------------------

return M
