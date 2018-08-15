local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local M = {}

---------------------------------

function M.pre_kite()
  return not algorithms.IsUnitLowHp(env.BOT_DATA)
         and (M.pre_attack_enemy_hero()
              or M.pre_move_safe())
end

function M.post_kite()
  return not M.pre_kite()
end

---------------------------------

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()

         and not algorithms.DoesEnemyCreepAttack(
                   env.BOT_DATA,
                   env.ENEMY_CREEP_DATA,
                   env.ALLY_CREEP_DATA)
         and not env.IS_FOCUSED_BY_CREEPS
         and not env.IS_FOCUSED_BY_TOWER
         and not algorithms.IsUnitAttackTarget(
                   env.BOT_DATA,
                   env.ENEMY_HERO_DATA)
end

function M.post_attack_enemy_hero()
  return not M.pre_attack_enemy_hero()
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

--------------------------------

function M.stop_attack()
  moves.stop_attack()
end

---------------------------------

function M.pre_move_safe()
  return env.ENEMY_HERO_DATA ~= nil
         and algorithms.IsUnitAttackTarget(
               env.BOT_DATA,
               env.ENEMY_HERO_DATA)
         and not algorithms.IsUnitMoving(env.BOT_DATA)
end

function M.post_move_safe()
  return not M.pre_move_safe()
end

function M.move_safe()
  env.BOT:Action_MoveToLocation(env.SAFE_SPOT)

  action_timing.SetNextActionDelay(0.4)
end

---------------------------------

-- Provide an access to local functions for unit tests only

return M
