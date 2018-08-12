local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_push_lane()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and env.ENEMY_HERO_DATA == nil
         and 4 <= env.BOT_DATA.level
         and (M.pre_lasthit_enemy_creep()
              or M.pre_deny_ally_creep()
              or M.pre_attack_enemy_creep()
              or M.pre_attack_enemy_tower())
end

function M.post_push_lane()
  return not M.pre_push_lane()
end

---------------------------------

local function IsRangedAllyCreep()
  local creeps = algorithms.GetAllyCreeps(
                   env.BOT_DATA,
                   constants.MAX_UNIT_SEARCH_RADIUS)

  return nil ~= functions.GetElementWith(
                  creeps,
                  algorithms.CompareMaxHealth,
                  function(unit_data)
                    return not algorithms.IsUnitLowHp(unit_data)
                           and algorithms.IsRangedUnit(unit_data)
                  end)
end

function M.pre_use_trueshot()
  local ability = env.BOT:GetAbilityByName("drow_ranger_trueshot")

  return not env.BOT_DATA.is_silenced
         and ability:IsFullyCastable()
         and IsRangedAllyCreep()
end

function M.post_use_trueshot()
  return not M.pre_use_trueshot()
end

function M.use_trueshot()
  local ability = env.BOT:GetAbilityByName("drow_ranger_trueshot")

  env.BOT:Action_UseAbility(ability)
end

---------------------------------

function M.pre_lasthit_enemy_creep()
  return moves.pre_lasthit_enemy_creep()
end

function M.post_lasthit_enemy_creep()
  return moves.post_lasthit_enemy_creep()
end

function M.lasthit_enemy_creep()
  moves.lasthit_enemy_creep()
end

---------------------------------

function M.pre_deny_ally_creep()
  return moves.pre_deny_ally_creep()
end

function M.post_deny_ally_creep()
  return moves.post_deny_ally_creep()
end

function M.deny_ally_creep()
  moves.deny_ally_creep()
end

--------------------------------

function M.pre_attack_enemy_creep()
  return moves.pre_attack_enemy_creep()
end

function M.post_attack_enemy_creep()
  return moves.post_attack_enemy_creep()
end

function M.attack_enemy_creep()
  moves.attack_enemy_creep()
end

--------------------------------

function M.pre_attack_enemy_tower()
  return moves.pre_attack_enemy_tower()
end

function M.post_attack_enemy_tower()
  return moves.post_attack_enemy_tower()
end

function M.attack_enemy_tower()
  moves.attack_enemy_tower()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
