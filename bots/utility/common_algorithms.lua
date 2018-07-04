local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local all_units = require(
  GetScriptDirectory() .."/utility/all_units")

local M = {}

function M.GetItem(unit, item_name)
  local slot = unit:FindItemSlot(item_name)

  return unit:GetItemInSlot(slot)
end

function M.IsItemPresent(unit, item_name)
  return M.GetItem(unit, item_name) ~= nil
end

function M.IsAttackTargetable(unit)
  return unit:IsAlive()
         and not unit:IsInvulnerable()
         and not unit:IsIllusion()
end

function M.CompareMinHealth(t, a, b)
  return t[a]:GetHealth() < t[b]:GetHealth()
end

local function GetNormalizedRadius(radius)
  if radius == nil or radius == 0 then
    return constants.DEFAULT_ABILITY_USAGE_RADIUS
  end

  -- TODO: Trick with MAX_ABILITY_USAGE_RADIUS breaks Sniper's ult.
  -- But the GetNearbyHeroes function has the maximum radius 1600.

  return functions.ternary(
    constants.MAX_ABILITY_USAGE_RADIUS < radius,
    constants.MAX_ABILITY_USAGE_RADIUS,
    radius)
end

function M.GetEnemyHeroes(bot, radius)
  return bot:GetNearbyHeroes(
    GetNormalizedRadius(radius),
    true,
    BOT_MODE_NONE)
end

-- Result of this fucntion includes the "bot" unit

function M.GetAllyHeroes(bot, radius)
  return bot:GetNearbyHeroes(
    GetNormalizedRadius(radius),
    false,
    BOT_MODE_NONE)
end

function M.GetEnemyCreeps(bot, radius)
  local enemy_creeps = bot:GetNearbyCreeps(
    GetNormalizedRadius(radius),
    true)

  local neutral_creeps = bot:GetNearbyNeutralCreeps(
    GetNormalizedRadius(radius))

  if enemy_creeps == nil or #enemy_creeps == 0 then
    return {} end

  if neutral_creeps == nil or #neutral_creeps == 0 then
    return enemy_creeps end

  return functions.ComplementOfLists(enemy_creeps, neutral_creeps, true)
end

function M.GetAllyCreeps(bot, radius)
  return bot:GetNearbyCreeps(GetNormalizedRadius(radius), false)
end

function M.GetTotalDamage(units, target)
  if units == nil or #units == 0 or target == nil then
    return 0 end

  local total_damage = 0

  functions.DoWithKeysAndElements(
    units,
    function(_, unit)
      if unit:IsAlive() and unit:GetAttackTarget() == target then
        total_damage = total_damage + unit:GetAttackDamage()
      end
    end)

  return total_damage
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius

return M
