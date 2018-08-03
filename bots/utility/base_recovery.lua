local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local logger = require(
  GetScriptDirectory() .."/utility/logger")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local map = require(
  GetScriptDirectory() .."/utility/map")

local M = {}

local BOT = {}
local BOT_DATA = {}
local SAFE_SPOT = {}
local FOUNTAIN_SPOT = {}

function M.UpdateVariables()
  BOT = GetBot()

  BOT_DATA = common_algorithms.GetBotData()

  SAFE_SPOT = common_algorithms.GetSafeSpot(BOT_DATA, ENEMY_HERO_DATA)

  FOUNTAIN_SPOT = map.GetAllySpot(BOT_DATA, "fountain")
end

---------------------------------

function M.pre_restore_hp_on_base()
  return BOT:HasModifier("modifier_fountain_aura_buff")
         and (BOT_DATA.health < BOT_DATA.max_health
              or BOT_DATA.mana < BOT_DATA.max_mana)
end

function M.post_restore_hp_on_base()
  return not M.pre_restore_hp_on_base()
end

function M.restore_hp_on_base()
  BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_base_recovery()
  return ((common_algorithms.IsUnitLowHp(BOT_DATA)
           and not BOT_DATA.is_healing)

          or M.pre_restore_hp_on_base()

          or (functions.GetRate(BOT_DATA.health, BOT_DATA.max_health)
              < constants.UNIT_HALF_HEALTH_LEVEL
              and functions.GetDistance(FOUNTAIN_SPOT, BOT_DATA.location)
                  < constants.BASE_RADIUS))
end

function M.post_base_recovery()
  return not M.pre_base_recovery()
end

---------------------------------

function M.pre_move_shrine()
  -- TODO: Implement this move
  return false
end

---------------------------------

function M.pre_move_base()

  return (not (common_algorithms.IsUnitMoving(BOT_DATA)
              and BOT:IsFacingLocation(FOUNTAIN_SPOT, 30)))
          or (functions.GetRate(BOT_DATA.health, BOT_DATA.max_health)
              < constants.UNIT_HALF_HEALTH_LEVEL
              and functions.GetDistance(FOUNTAIN_SPOT, BOT_DATA.location)
                  < constants.BASE_RADIUS)
end

function M.post_move_base()
  return not M.pre_move_base()
end

function M.move_base()
  BOT:Action_MoveToLocation(FOUNTAIN_SPOT)

  if functions.GetDistance(FOUNTAIN_SPOT, BOT_DATA.location)
     < constants.BASE_RADIUS
     and not BOT:HasModifier("modifier_fountain_aura_buff") then

    action_timing.SetNextActionDelay(1.5)
  end
end

---------------------------------

function M.pre_deliver_items()
  local courier_data = common_algorithms.GetCourierData()

  return 0 < BOT_DATA.stash_value
         and map.IsUnitInSpot(
               courier_data,
               map.GetAllySpot(BOT_DATA, "fountain"))
end

function M.post_deliver_items()
  return not M.pre_deliver_items()
end

function M.deliver_items()
  local courier = GetCourier(0)

  BOT:ActionImmediate_Courier(
    courier,
    COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
end

---------------------------------

return M
