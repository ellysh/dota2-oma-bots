local algorithms = require(
  GetScriptDirectory() .."/utility/algorithms")

local env = require(
  GetScriptDirectory() .."/utility/environment")

local moves = require(
  GetScriptDirectory() .."/utility/moves")

local M = {}

---------------------------------

function M.pre_attack_with_better_position()
  return algorithms.IsBotAlive()
         and not env.IS_BOT_LOW_HP
end

---------------------------------

local function IsUnitPositionBetter(unit_data, target_data)
  return GetHeightLevel(unit_data.location)
         < GetHeightLevel(target_data.location)
end

local function IsUnitIncomingDamageMore(unit_data, target_data)
  return (target_data.incoming_damage_from_creeps
          + target_data.incoming_damage_from_towers)
         < (unit_data.incoming_damage_from_creeps
          + unit_data.incoming_damage_from_towers)

end

function M.pre_attack_enemy_hero()
  return moves.pre_attack_enemy_hero()

         and ((IsUnitPositionBetter(env.BOT_DATA, env.ENEMY_HERO_DATA)
               and not IsUnitIncomingDamageMore(
                         env.BOT_DATA,
                         env.ENEMY_HERO_DATA))

              or (IsUnitIncomingDamageMore(
                    env.ENEMY_HERO_DATA,
                    env.BOT_DATA)
                  and not IsUnitPositionBetter(
                            env.ENEMY_HERO_DATA,
                            env.BOT_DATA)))
end

function M.attack_enemy_hero()
  moves.attack_enemy_hero()
end

-- Provide an access to local functions for unit tests only

return M
