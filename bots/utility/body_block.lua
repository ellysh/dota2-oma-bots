local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_body_block()
  return 0 < DotaTime()
         and DotaTime() < 20
         and M.pre_move_and_block()
end

function M.post_body_block()
  return not M.pre_body_block()
end

---------------------------------

local function AreAllyCreepsInRadius(radius)
  return algorithms.AreUnitsInRadius(
    env.BOT_DATA,
    radius,
    algorithms.GetAllyCreeps)
end

local function AreEnemyCreepsInRadius(radius)
  return algorithms.AreUnitsInRadius(
    env.BOT_DATA,
    radius,
    algorithms.GetEnemyCreeps)
end

function M.pre_move_and_block()
  return AreAllyCreepsInRadius(constants.BASE_CREEP_DISTANCE)
         and not AreEnemyCreepsInRadius(constants.MAX_CREEP_DISTANCE)
end

function M.post_move_and_block()
  return not M.pre_move_and_block()
end

function M.move_and_block()
  local unit = all_units.GetUnit(env.ALLY_CREEP_DATA)
  local target_location = unit:GetExtrapolatedLocation(2)

  env.BOT:Action_MoveToLocation(target_location)

  action_timing.SetNextActionDelay(1)
end

function M.stop_attack_and_move()
  env.BOT:Action_ClearActions(true)

  action_timing.SetNextActionDelay(0.2)
end

---------------------------------


-- Provide an access to local functions for unit tests only

return M
