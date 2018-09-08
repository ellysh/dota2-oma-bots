local functions = require(
  GetScriptDirectory() .."/utility/functions")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local M = {}

---------------------------------

function M.pre_recovery()
  return not algorithms.IsBotAlive()
         or env.IS_BOT_LOW_HP
end

local function GetDelta()
end

local function IsBiggerThan(a, b, delta)
  if a < b then
    return false end

  return delta <= functions.GetDelta(a, b)
end

local function DoesUnitHasAdvantage(unit_data, target_data)
  return unit_data ~= nil
         and target_data ~= nil
         and (IsBiggerThan(
                unit_data.attack_damage,
                target_data.attack_damage,
                50)
              or IsBiggerThan(
                   unit_data.health,
                   target_data.health,
                   300)
              or IsBiggerThan(
                   unit_data.speed,
                   target_data.speed,
                   40)
              or IsBiggerThan(
                   unit_data.attack_range,
                   target_data.attack_range,
                   100))
end

function M.pre_defensive()
  return DoesUnitHasAdvantage(env.ENEMY_HERO_DATA, env.BOT_DATA)
end

function M.pre_offensive()
  return env.ENEMY_HERO_DATA == nil
         or DoesUnitHasAdvantage(env.BOT_DATA, env.ENEMY_HERO_DATA)
end

function M.pre_farm()
  return true
end

---------------------------------

return M
