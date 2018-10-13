local functions = require(
  GetScriptDirectory() .."/utility/functions")

local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local action_timing = require(
  GetScriptDirectory() .."/utility/action_timing")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local map = require(
  GetScriptDirectory() .."/utility/map")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_base_recovery()
  return algorithms.IsBotAlive()

         and ((env.IS_BOT_LOW_HP
               and not env.BOT_DATA.is_healing)
              or env.IS_BASE_RECOVERY)
end

---------------------------------

function M.pre_use_silence()
  return moves.pre_use_silence()
         and env.IS_BOT_LOW_HP
         and (map.IsUnitInEnemyTowerAttackRange(env.BOT_DATA)

              or map.IsUnitInSpot(
                   env.BOT_DATA,
                   map.GetEnemySpot("high_ground"))

              or (algorithms.HasModifier(
                    env.BOT_DATA,
                    "modifier_drow_ranger_frost_arrows_slow")

                 and env.ENEMY_HERO_DISTANCE <= constants.MIN_HERO_DISTANCE))
end

function M.use_silence()
  moves.use_silence()
end

---------------------------------

function M.pre_restore_hp_on_base()
  return algorithms.HasModifier(
           env.BOT_DATA,
           "modifier_fountain_aura_buff")

         and (functions.GetRate(
                env.BOT_DATA.health,
                env.BOT_DATA.max_health)
              < constants.UNIT_FOUNTAIN_MAX_HEALTH
              or functions.GetRate(
                   env.BOT_DATA.mana,
                   env.BOT_DATA.max_mana)
                 < constants.UNIT_FOUNTAIN_MAX_MANA)
end

function M.restore_hp_on_base()
  env.BOT:Action_ClearActions(true)
end

---------------------------------

function M.pre_move_base()
  return true
end

function M.move_base()
  env.BOT:Action_MoveDirectly(env.FOUNTAIN_SPOT)

  if functions.GetDistance(env.FOUNTAIN_SPOT, env.BOT_DATA.location)
     < constants.BASE_RADIUS
     and not algorithms.HasModifier(
               env.BOT_DATA,
               "modifier_fountain_aura_buff") then

    action_timing.SetNextActionDelay(1.5)
  else
    action_timing.SetNextActionDelay(0.2)
  end
end

---------------------------------

function M.pre_deliver_items()
  return moves.pre_deliver_items()
end

function M.deliver_items()
  moves.deliver_items()
end

---------------------------------

return M
